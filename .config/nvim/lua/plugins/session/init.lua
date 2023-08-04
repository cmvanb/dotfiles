local sessions = require('sessions')

return sessions.setup({
    -- Use absolute path.
    absolute = true,

    -- Path where session files are saved.
    session_filepath = vim.fn.stdpath('data') .. '/sessions',
})
