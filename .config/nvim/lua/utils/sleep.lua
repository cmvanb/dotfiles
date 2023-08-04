--------------------------------------------------------------------------------
-- Sleep
--------------------------------------------------------------------------------

function _G.sleep(seconds)
    local wake_time = tonumber(os.clock() + seconds); 
    while (os.clock() < wake_time) do 
    end 
end

