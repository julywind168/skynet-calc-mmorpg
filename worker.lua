package.cpath = "luaclib/?.so;"..package.cpath
local calc = require "skynet.calc"

local game = require "game".game
local gamex = require "game.extend"


local function exec(session, cmd, ...)
    local f = assert(game[cmd], string.format("Undefined action %s", tostring(cmd)))
    if session == 0 then
        f(game, ...)
    else
        local r = f(game, ...)
        return calc.pack(r, gamex:collect("socket_push"), gamex:collect("mongo_actions"))
    end
end


function handle(session, data, sz)
    return exec(session, calc.unpack(data, sz))
end

collectgarbage("stop")