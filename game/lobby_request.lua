local calc = require "skynet.calc"


return function(game, lock, new)

    local function myplayer(pid)
        return game.lobby.players[pid]
    end

    lock("lobby.players.#pid")(function ()

        function game:sign()
            return myplayer(self.pid):sign()
        end

    end)
end
