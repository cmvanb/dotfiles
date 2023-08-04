--------------------------------------------------------------------------------
-- Debug utilities
--------------------------------------------------------------------------------

function _G.dump_table(...)
    local objects = vim.tbl_map(vim.inspect, { ... })
    print(unpack(objects))
end

