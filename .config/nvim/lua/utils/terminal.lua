--------------------------------------------------------------------------------
-- Terminal integration utilities
--------------------------------------------------------------------------------

function _G.is_linux_virtual_terminal()
    -- NOTE: For some reason, neovide identifies as a virtual terminal.
    if vim.g.neovide then
        return false
    end
    if os.getenv('TERM') == 'linux' then
        return true
    end
    return false
end
