--------------------------------------------------------------------------------
-- Miscellaneous theme configuration
--------------------------------------------------------------------------------

local Config = {}

Config.border =
    not is_linux_virtual_terminal()
        and 'rounded'
        or 'single'

return Config
