set -gx PNPM_HOME "$XDG_DATA_HOME/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
