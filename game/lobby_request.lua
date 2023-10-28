local calc = require "skynet.calc"


return function(game, lock)

    local function myplayer(pid)
        return game.lobby.players[pid]
    end

    lock("lobby.players.#1")(function ()

        function game:sign(pid)
            return myplayer(pid):sign()
        end

    end)
end
