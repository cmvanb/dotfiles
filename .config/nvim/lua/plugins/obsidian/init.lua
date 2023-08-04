--------------------------------------------------------------------------------
-- Obsidian notes integration
--------------------------------------------------------------------------------

require('obsidian').setup({
    dir = '~/Documents/vaults/home',
    completion = {
        nvim_cmp = true,
    },
    note_id_func = function(title)
        local file_name = ''

        if title ~= nil then
            file_name = title:gsub(' ', '-'):gsub("[^A-Za-z0-9-]", ""):lower()
        else
            file_name = 'unnamed-note-' .. tostring(os.time())
        end

        return file_name
    end
})

