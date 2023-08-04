--------------------------------------------------------------------------------
-- Packer configuration
--------------------------------------------------------------------------------

local packer_compiled_path = vim.fn.stdpath('data') .. '/plugin/packer_compiled.lua'

return {
    compile_path = packer_compiled_path,
    display = {
        prompt_border = 'rounded',
        open_fn = function()
            return require('packer.util').float({ border = 'rounded' })
        end,
    },
}
