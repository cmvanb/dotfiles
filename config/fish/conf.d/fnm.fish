if status is-interactive
and command -v fnm >/dev/null
    fnm env --use-on-cd --shell fish | source
end
