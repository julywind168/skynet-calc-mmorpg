local calc = require "skynet.calc"
local ScenePlayer = require "gameclass.ScenePlayer"


return function(game, lock, new)

    local function myplayer(pid)
        return game.lobby.players[pid]
    end

    local function myscene(sid)
        return game.scenes[sid]
    end

    lock("lobby.players.#1, scenes.#2")(function ()

        function game:scene_info(pid, sid)
            return myscene(sid):info()
        end

        function game:scene_join(pid, sid, rtt)
            if myscene(sid):find_player(pid) then
                return myscene(sid):info()
            end
            return myscene(sid):join(new(ScenePlayer, {base = myplayer(pid), rtt = rtt}):init())
        end

        function game:scene_sync_my_position(pid, sid, position)
            myscene(sid):sync_position(pid, position)
        end
    end)
end
