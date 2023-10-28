package.cpath = "luaclib/?.so;"..package.cpath
local calc = require "skynet.calc"

local game = require "game".game

local function exec(cmd, ...)
    local f = assert(game[cmd], string.format("Undefined action %s", tostring(cmd)))
    return calc.pack(f(game, ...))
end

function handle(data, sz)
    return exec(calc.unpack(data, sz))
end

collectgarbage("stop")