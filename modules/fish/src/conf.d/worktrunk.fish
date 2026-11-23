if status is-interactive
and command -v wt >/dev/null
    wt config shell init fish | source
end
