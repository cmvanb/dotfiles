--------------------------------------------------------------------------------
-- Packer configuration
--------------------------------------------------------------------------------

local ThemeConfig = reload('theme.config')
local ThemeSymbols = reload('theme.symbols')

local packer_config = {
    compile_path = vim.fn.stdpath('data') .. '/plugin/packer_compiled.lua',
    display = {
        prompt_border = ThemeConfig.border,
        open_fn = function()
            return require('packer.util').float({ border = ThemeConfig.border })
        end,
        working_sym = ThemeSymbols.packer.working,
        error_sym = ThemeSymbols.packer.error,
        done_sym = ThemeSymbols.packer.done,
        removed_sym = ThemeSymbols.packer.removed,
        moved_sym = ThemeSymbols.packer.moved,
        header_sym = ThemeSymbols.packer.header,
    },
}

return packer_config
