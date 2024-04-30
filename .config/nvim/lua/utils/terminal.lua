--------------------------------------------------------------------------------
-- Terminal integration utilities
--------------------------------------------------------------------------------

function _G.is_linux_virtual_terminal()
    if os.getenv('TERM') == 'linux' then
        return true
    end
    return false
end
