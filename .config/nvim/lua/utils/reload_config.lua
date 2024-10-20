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

    -- TODO: Restore reload plugins functionality.

    -- Load autocommands.
    reload('autocommands')

    -- Load key mappings last.
    reload('editor.keymaps')
end
