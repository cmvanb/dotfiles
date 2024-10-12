--------------------------------------------------------------------------------
-- Manually reload config
--------------------------------------------------------------------------------

function _G.reload_config()
    -- Load editor config.
    reload('editor.options')
    reload('editor.highlights')

    -- Load autocommands.
    reload('autocommands')

    -- Clear search highlight.
    vim.cmd('noh')

    -- Load key mappings last.
    reload('editor.keymaps')

    -- TODO: Restore reload plugins functionality.
end
