#-------------------------------------------------------------------------------
# Pyenv integration
#-------------------------------------------------------------------------------

# Add python shims to path.
fish_add_path -pP $PYENV_ROOT/bin

if status is-interactive
and command -v pyenv &> /dev/null
    # Lazy load pyenv init.
    # see: https://github.com/pyenv/pyenv/issues/2918
    function pyenv
        functions -e pyenv
        command pyenv init - fish | source
        pyenv $argv
    end
end
