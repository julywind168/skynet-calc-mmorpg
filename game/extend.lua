local gamex = {
    socket_push = {},  -- {msg => players, ...}
    mongo_action = {}, -- {action, ...}

}


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