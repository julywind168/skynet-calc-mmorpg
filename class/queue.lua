-- FIFO Queue (no limit size)

local function new()
    local queue = {}
    local size = 0
    local head = 1
    local tail = 0

    local self = {}

    function self.get()
        if size > 0 then
            local value = queue[head]
            queue[head] = nil
            head = head + 1
            size = size - 1
            return value
        end
    end

    function self.put(value)
        tail = tail + 1
        size = size + 1
        queue[tail] = value
        return self
    end

    function self.size()
        return size
    end

    return self
end

return new
