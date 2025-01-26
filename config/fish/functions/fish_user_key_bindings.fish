#-------------------------------------------------------------------------------
# Fish key bindings
#-------------------------------------------------------------------------------

function fish_user_key_bindings
    # Unbind presets
    # NOTE: This doesn't work as expected. It might work in the function `fish_user_key_bindings`.
    bind --erase --all --preset
    bind --erase --all

    # Default binding if there is no match
    bind '' self-insert

    # Expand abbreviations
    bind ' ' self-insert expand-abbr
    bind ';' self-insert expand-abbr
    bind '|' self-insert expand-abbr
    bind '&' self-insert expand-abbr
    bind '>' self-insert expand-abbr
    bind '<' self-insert expand-abbr
    bind ')' self-insert expand-abbr

    # Bracketed paste
    bind --preset -m paste \e\[200\~ __fish_start_bracketed_paste
    bind --preset -M paste \e\[201\~ __fish_stop_bracketed_paste
    bind --preset -M paste '' self-insert
    bind --preset -M paste \r commandline\ -i\ \\n
    bind --preset -M paste \' __fish_commandline_insert_escaped\ \\\'\ \$__fish_paste_quoted
    bind --preset -M paste \\ __fish_commandline_insert_escaped\ \\\\\ \$__fish_paste_quoted
    bind --preset -M paste ' ' self-insert-notfirst

    # Basics
    bind \e\[A up-or-search  # Up
    bind \e\[B down-or-search  # Down
    bind \e\[D backward-char  # Left
    bind \e\[C forward-char  # Right
    bind \e\[H beginning-of-line  # Home
    bind \e\[F end-of-line  # End
    bind -k backspace backward-delete-char
    bind -k dc delete-char
    bind \r execute
    bind \e cancel

    # Clipboard
    bind \cc fish_clipboard_copy
    bind \cv fish_clipboard_paste

    # Completion
    bind \t accept-autosuggestion
    bind \cj complete

    # History
    bind \ck history-pager
    bind \cz undo
    bind \e\[1\;5A undo  # Ctrl+Up
    bind \e\[1\;5B redo  # Ctrl+Down

    # Word navigation
    bind \ch backward-bigword
    bind \cl forward-bigword
    bind \e\[1\;5D backward-bigword  # Ctrl+Left
    bind \e\[1\;5C forward-bigword  # Ctrl+Right

    # Kill-ring
    bind \eh backward-kill-line
    bind \ej backward-kill-word
    bind \ek kill-word
    bind \el kill-line
    bind \e\; yank  # yank means paste

    # Editing
    bind \eu downcase-word
    bind \eU upcase-word

    # Open file browser
    bind \cf 'lfcd; commandline -f repaint'

    # Open editor
    bind \ce 'edit; commandline -f repaint'

    # Open python interpreter
    bind \cr 'python; commandline -f repaint'

    # Clear command line
    # NOTE: Ctrl+C is bound to `Copy` by the terminal emulator, so we also remapped
    # Ctrl+X to send Ctrl+C.
    bind \cc 'commandline -r ""'

    # Clear screen
    bind \cs 'tput reset; commandline -f repaint'

    # List all files
    bind \cu 'clear; commandline -f repaint; eza -al | view.sh'

    # List all files in tree format
    # NOTE: Fish normally cannot interpret Ctrl+I, so we use the terminal emulator
    # to remap it to F13.
    bind -k f13 'clear; commandline -f repaint; eza -aT --git-ignore | view.sh'

    # Expand ... to ../..
    bind . 'expand-dot-to-double-dot'
end
