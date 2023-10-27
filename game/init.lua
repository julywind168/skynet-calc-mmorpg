local moudle = {
    "lobby_login",
}

local game = {
    lobby = {
        online = 0,
        players = {}
    }
}

local rwlock = {}

    
local function LOCK(lock)
    return function (f)
        f()
        for k,v in pairs(game) do
            if type(v) == "function" and not rwlock[k] then
                rwlock[k] = lock
            end
        end
    end
end


for _, m in ipairs(moudle) do
    local f = require(string.format("game.%s", m))
    f(game, LOCK)
end


return { game = game, rwlock = rwlock }
