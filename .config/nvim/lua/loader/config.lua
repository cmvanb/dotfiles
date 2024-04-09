--------------------------------------------------------------------------------
-- Packer configuration
--------------------------------------------------------------------------------

local TableUtils = reload('utils.table')

local packer_config = {
    compile_path = vim.fn.stdpath('data') .. '/plugin/packer_compiled.lua',
    display = {
        prompt_border = 'rounded',
        open_fn = function()
            return require('packer.util').float({ border = 'rounded' })
        end,
        working_sym = '',
        error_sym = '⨯',
        done_sym = '',
        removed_sym = '-',
        moved_sym = '󰁔',
        header_sym = '─',
    },
}

if is_linux_terminal() then
    packer_config = TableUtils.merge(
        packer_config,
        {
            display = {
                prompt_border = 'single',
                open_fn = function()
                    return require('packer.util').float({ border = 'single' })
                end,
                working_sym = '?',
                error_sym = 'x',
                done_sym = 'O',
                removed_sym = '-',
                moved_sym = '→',
                header_sym = '─',
            }
        })
end

return packer_config
