--------------------------------------------------------------------------------
-- Manually reload config
--------------------------------------------------------------------------------

function _G.reload_config()
    -- Clear search highlight.
    vim.cmd('noh')

    -- Load editor config.
    reload('editor.gui')
    reload('editor.options')
    reload('editor.highlights')

    -- TODO: Restore plugin reloading; requires a different plugin manager.
    -- Load plugins. Will bootstrap Lazy.nvim if necessary.
    -- reload('plugins.manager')

    -- Load autocommands.
    reload('autocommands')

    -- Load key mappings last.
    reload('editor.keymaps')

    vim.api.nvim_echo({
        { 'Neovim configuration reloaded.' },
    }, true, {})
end
