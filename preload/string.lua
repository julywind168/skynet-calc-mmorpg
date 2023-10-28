local CHARS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

function string.random_str(length)
    local result = {}
    for i = 1, length do
        local idx = math.random(1, #CHARS)
        table.insert(result, CHARS:sub(idx, idx))
    end
    return table.concat(result)
end

function string:trim()
    return (self:gsub("^%s*(.-)%s*$", "%1"))
end

function string:split(sep)
    local splits = {}
    
    if sep == nil then
        table.insert(splits, self)
    elseif sep == "" then
        local len = #self
        for i = 1, len do
            table.insert(splits, self:sub(i, i))
        end
    else
        local pattern = "[^" .. sep .. "]+"
        for str in string.gmatch(self, pattern) do
            table.insert(splits, str)
        end
    end
    
    return splits
end