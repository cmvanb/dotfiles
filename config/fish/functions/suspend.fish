#-------------------------------------------------------------------------------
# Suspend the system.
#
# NOTE: We don't use the shell's builtin suspend command.
#-------------------------------------------------------------------------------

function suspend
    $XDG_BIN_HOME/suspend
end
