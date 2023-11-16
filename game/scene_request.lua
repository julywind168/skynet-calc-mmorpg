local calc = require "skynet.calc"
local ScenePlayer = require "gameclass.ScenePlayer"


return function(game, lock, new)

    local function myplayer(pid)
        return game.lobby.players[pid]
    end

    local function myscene(sid)
        return game.scenes[sid]
    end

    lock("lobby.players.#pid, scenes.#sid")(function ()

        function game:scene_info()
            return myscene(self.sid):info()
        end

        function game:scene_join()
            if myscene(self.sid):find_player(self.pid) then
                return myscene(self.sid):info()
            end
            return myscene(self.sid):join(new(ScenePlayer, {base = myplayer(self.pid), rtt = self.rtt}):init())
        end

        function game:scene_sync_my_position()
            myscene(self.sid):sync_position(self.pid, self.position)
        end
    end)
end
