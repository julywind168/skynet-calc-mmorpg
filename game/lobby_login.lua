local calc = require "skynet.calc"
local db = require "game.extend".db
local LobbyPlayer = require "gameclass.LobbyPlayer"
local ScenePlayer = require "gameclass.ScenePlayer"



return function(game, lock, new)

    lock("lobby")(function ()
        function game:login(pid, p)
            -- calc.error(string.format("player login ok %s", table.tostring(p)))
            self.lobby.players[pid] = new(LobbyPlayer, p)
            self.lobby.online = self.lobby.online + 1
        end
    end)

    lock("*")(function()
        function game:logout(pid)
            self.lobby.players[pid] = nil
            self.lobby.online = self.lobby.online - 1
            local scene = self.scenes["main"]:leave(pid)
            if scene then
                db.player.patch({id = pid}, {scene = scene})
            end
        end
    end)
end
