--------------------------------------------------------------------------------
-- Manually reload config
--------------------------------------------------------------------------------

function _G.reload_config()
    -- Load editor config.
    reload('editor.options')
    reload('editor.gui')
    reload('editor.highlights')

    -- Load autocommands.
    reload('autocommands')

    -- Clear search highlight.
    vim.cmd('noh')

    -- Reload plugins.
    Loader.reload_plugins(function()
        -- Load key mappings last; some key mappings may depend on plugins.
        reload('editor.keymaps')

        vim.notify('Configuration reloaded.')
    end)
end
