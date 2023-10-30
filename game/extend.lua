local gamex = {
    socket_push = {},  -- {msg => players, ...}
    mongo_actions = {}

}

local cache = {}

local function collection(coll)
    local c = cache[coll]
    if not c then
        c = setmetatable({}, {__index = setmetatable({}, {__index = function (_, action)
            return function (...)
                table.insert(gamex.mongo_actions, {
                    coll = coll,
                    action = action,
                    params = {...}
                })
            end
        end})})
        cache[coll] = c
    end
    return c
end


gamex.db = setmetatable({}, {__index = function (_, coll)
    return collection(coll)
end})



function gamex:newpush(msg)
    local function push(pid)
        self.socket_push[msg] = self.socket_push[msg] or {}
        table.insert(self.socket_push[msg], pid)
        return push
    end
    return push
end


function gamex:collect(key)
    local t = self[key]
    if next(t) then
        self[key] = {}
        return t
    else
        return nil
    end
end


return gamex