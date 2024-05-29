--------------------------------------------------------------------------------
-- Disable builtin plugins (improves startup performance)
--------------------------------------------------------------------------------

local builtin_plugins = {
    ['gzip']              = false,
    ['tar']               = false,
    ['tarPlugin']         = false,
    ['zip']               = false,
    ['zipPlugin']         = false,
    ['getscript']         = false,
    ['getscriptPlugin']   = false,
    ['vimball']           = false,
    ['vimballPlugin']     = false,
    ['matchit']           = false,
    ['matchparen']        = false,
    ['2html_plugin']      = false,
    ['logiPat']           = false,
    ['rrhelper']          = false,
    ['netrw']             = false,
    ['netrwPlugin']       = false,
    ['netrwSettings']     = false,
    ['netrwFileHandlers'] = false,
}

for plugin, enabled in pairs(builtin_plugins) do
    if not enabled then
        vim.g['loaded_' .. plugin] = 1
    end
end
