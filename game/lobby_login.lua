local calc = require "skynet.calc"
local LobbyPlayer = require "gameclass.LobbyPlayer"



return function(game, lock, new)

    lock("lobby")(function ()
        function game:login(pid, p)
            calc.error(string.format("player login ok, %s", table.tostring(p)))
            self.lobby.players[pid] = new(LobbyPlayer, p)
            self.lobby.online = self.lobby.online + 1
        end

        function game:logout(pid)
            self.lobby.players[pid] = nil
            self.lobby.online = self.lobby.online - 1
        end
    end)
end
