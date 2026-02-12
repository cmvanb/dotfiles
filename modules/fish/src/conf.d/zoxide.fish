if status is-interactive
and command -v zoxide >/dev/null
    zoxide init fish | source
end
