--------------------------------------------------------------------------------
-- System theme colors
--------------------------------------------------------------------------------

local PathUtils = require('utils.path')

PathUtils.prepend_to_package_path(
    os.getenv('XDG_OPT_HOME') .. [[/theme/?.lua]]
)

return require('theme')
