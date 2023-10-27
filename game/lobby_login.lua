local calc = require "skynet.calc"


return function(game, LOCK)

    LOCK("lobby")(function ()
        function game:login(pid, ip)
            calc.error(string.format("player %s login from: %s", pid, ip))
            self.lobby.players[pid] = {
                id = pid,
                ip = ip
            }
            self.lobby.online = self.lobby.online + 1
            return self.lobby.players[pid]
        end

        function game:logout(pid)
            self.lobby.players[pid] = nil
            self.lobby.online = self.lobby.online - 1
        end
    end)
end
