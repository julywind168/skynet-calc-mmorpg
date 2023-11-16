local calc = require "skynet.calc"
local db = require "game.extend".db
local LobbyPlayer = require "gameclass.LobbyPlayer"
local ScenePlayer = require "gameclass.ScenePlayer"



return function(game, lock, new)

    lock("lobby")(function ()
        function game:login()
            -- calc.error(string.format("player login ok %s", table.tostring(self.p)))
            game.lobby.players[self.p.id] = new(LobbyPlayer, self.p)
            game.lobby.online = game.lobby.online + 1
        end
    end)

    lock("*")(function()
        function game:logout()
            game.lobby.players[self.pid] = nil
            game.lobby.online = game.lobby.online - 1
            local scene = game.scenes["main"]:leave(self.pid)
            if scene then
                db.player.patch({id = self.pid}, {scene = scene})
            end
        end
    end)
end
