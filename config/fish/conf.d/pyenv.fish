#-------------------------------------------------------------------------------
# Pyenv integration
#-------------------------------------------------------------------------------

# Add python shims to path.
fish_add_path -pP $PYENV_ROOT/bin

if status is-interactive
and command -v pyenv &> /dev/null
    pyenv init - | source
end
