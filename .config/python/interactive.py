#-------------------------------------------------------------------------------
# XDG compliant python history path
#
# What a nightmare hack... PYTHON! GET YOUR SHIT TOGETHER!
#   see: https://github.com/python/cpython/issues/88405
#
# Based on gist by alichtman:
#   see: https://gist.github.com/viliampucik/8713b09ff7e4d984b29bfcd7804dc1f4?permalink_comment_id=4582040#gistcomment-4582040
#-------------------------------------------------------------------------------

try:
    import sys
    import os
    import atexit
    import readline
    from pathlib import Path
except ImportError as e:
    print(f'`interactive.py` couldn\'t load module: {e}')
    sys.exit(1)

# Delete default history write hook.
if hasattr(sys, '__interactivehook__'):
    del sys.__interactivehook__

# Restore tab completion (collateral damage from previous hook deletion).
try:
    readline.parse_and_bind('tab: complete')
except ImportError:
    pass

# Configure XDG compliant history path.
python_history = Path(os.getenv('XDG_DATA_HOME', Path.home() / '.local/share')) / 'python' / 'python_history'
try:
    python_history.touch(exist_ok=True)
except FileNotFoundError: 
    python_history.parent.mkdir(parents=True, exist_ok=True)

# Read existing history.
try:
    readline.read_history_file(python_history)
except OSError:
    pass

# Register new history write hook.
def write_history():
    try:
        readline.write_history_file(python_history)
    except OSError:
        pass

atexit.register(write_history)
