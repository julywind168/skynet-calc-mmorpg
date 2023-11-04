require "preload.enum"
require "preload.string"
require "preload.table"
require "preload.calc.dump"

local moudle = {
    "lobby_login",
    "lobby_request",
    "scene_request"
}

local game = {
    lobby = {
        online = 0,
        players = {}
    },
    scenes = {}
}

local rwlock = {}

    
local function lock(str)
    return function (f)
        f()
        for k,v in pairs(game) do
            if type(v) == "function" and not rwlock[k] then
                rwlock[k] = str
            end
        end
    end
end


local function new(gameclass, self)
    return setmetatable(self or {}, {__index = gameclass})
end


for _, m in ipairs(moudle) do
    local f = require(string.format("game.%s", m))
    f(game, lock, new)
end


return { game = game, rwlock = rwlock }
