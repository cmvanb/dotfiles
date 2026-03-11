#!/usr/bin/env python3
# ------------------------------------------------------------------------------
# Markdown preview HTTP server.
#
# Usage: preview-server.py <md_path> <html_path> <markdown_to_html_script>
#
# 1. Binds to a random free port and prints it to stdout.
# 2. Daemonizes (double-fork) so the calling shell can exit immediately.
# 3. Starts `entr` to watch <md_path> and re-run <markdown_to_html_script>.
# 4. Serves GET / with the rendered HTML + an injected JS heartbeat.
# 5. Accepts POST /ping to reset the inactivity timer.
# 6. Kills entr and exits after TIMEOUT seconds with no ping from the browser.
# ------------------------------------------------------------------------------

import http.server
import os
import signal
import subprocess
import sys
import threading
import time

TIMEOUT = 5   # seconds of silence after last ping before shutdown
POLL    = 1   # watchdog polling interval (seconds)

HEARTBEAT_JS = """\
<script>
(function () {
  function ping() { fetch('/ping', { method: 'POST' }).catch(function () {}); }
  ping();
  setInterval(ping, 3000);
  document.addEventListener('visibilitychange', function () {
    if (document.visibilityState === 'hidden') ping();
  });
}());
</script>
"""


def daemonize() -> None:
    """Double-fork to fully detach from the calling terminal."""
    # First fork: parent exits, child becomes orphan adopted by init.
    if os.fork() > 0:
        sys.exit(0)

    os.setsid()  # new session — detach from controlling terminal

    # Second fork: prevents the daemon from reacquiring a terminal.
    if os.fork() > 0:
        sys.exit(0)

    # Redirect stdin/stdout/stderr to /dev/null.
    devnull = os.open(os.devnull, os.O_RDWR)
    for fd in (0, 1, 2):
        os.dup2(devnull, fd)
    os.close(devnull)


def main() -> None:
    if len(sys.argv) != 4:
        print(
            f"Usage: {sys.argv[0]} <md_path> <html_path> <markdown_to_html_script>",
            file=sys.stderr,
        )
        sys.exit(1)

    md_path    = sys.argv[1]
    html_path  = sys.argv[2]
    conv_script = sys.argv[3]

    # None until the browser sends its first ping so a slow browser open
    # doesn't trigger the inactivity timeout before the page has loaded.
    last_ping: list[float | None] = [None]

    class Handler(http.server.BaseHTTPRequestHandler):
        def log_message(self, fmt: str, *args: object) -> None:  # type: ignore[override]
            pass  # suppress access log

        def do_GET(self) -> None:
            if self.path != '/':
                self.send_error(404)
                return
            try:
                body = open(html_path, 'rb').read()
            except FileNotFoundError:
                self.send_response(503)
                self.send_header('Content-Type', 'text/plain')
                self.end_headers()
                self.wfile.write(b'Rendering not ready yet; please refresh.')
                return
            injected = body.replace(
                b'</body>',
                HEARTBEAT_JS.encode() + b'</body>',
                1,
            )
            self.send_response(200)
            self.send_header('Content-Type', 'text/html; charset=utf-8')
            self.send_header('Content-Length', str(len(injected)))
            self.end_headers()
            self.wfile.write(injected)

        def do_POST(self) -> None:
            if self.path == '/ping':
                last_ping[0] = time.monotonic()
                self.send_response(204)
                self.end_headers()
            else:
                self.send_error(404)

    # Bind to a random free port before forking so we can print it to the
    # parent process on stdout while we still have a real stdout.
    httpd = http.server.HTTPServer(('127.0.0.1', 0), Handler)
    port = httpd.server_address[1]

    # Print port to the parent shell, then daemonize.
    print(port, flush=True)
    daemonize()

    # --- we are now the daemon ---

    # Start entr to re-run the conversion script whenever the md file changes.
    entr_proc = subprocess.Popen(
        ['entr', '-n', '-r', conv_script, md_path],
        stdin=subprocess.PIPE,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    entr_proc.stdin.write((md_path + '\n').encode())  # type: ignore[union-attr]
    entr_proc.stdin.close()                            # type: ignore[union-attr]

    def watchdog() -> None:
        while True:
            time.sleep(POLL)
            t = last_ping[0]
            if t is not None and time.monotonic() - t > TIMEOUT:
                entr_proc.terminate()
                httpd.shutdown()

    threading.Thread(target=watchdog, daemon=True).start()
    httpd.serve_forever()


if __name__ == '__main__':
    main()
