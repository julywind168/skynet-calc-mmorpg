local skynet = require "skynet"
local socket = require "skynet.socket"
local websocket = require "http.websocket"
local json = require "json"
local new_gate = require "class.gate"
local new_mongo = require "class.mongo"
local new_request = require "game_request"
local mongo_conf = require "conf.mongo"

local calc = {}
local db = new_mongo(mongo_conf)
local request = new_request(db, calc)


-- req: {cmd, ...}
local function handle(pid, req)
    local cmd = req[1]
    local f = request[cmd]
    if f then
        return f(pid, table.unpack(req, 2))
    else
        table.insert(req, 2, pid)               -- client request, param #1 default pid
        return calc.call(table.unpack(req))
    end
end

local gate = new_gate(handle)


function calc.call(...)
	local r, push, mongo_actions = skynet.call("CALCULATOR", "lua", ...)
    skynet.fork(function ()
        if push then
            for msg,players in pairs(push) do
                for i,pid in ipairs(players) do
                    gate:send_push(pid, msg)
                end
            end
        end

        if mongo_actions then
            -- todo
        end
    end)
    return r
end

function calc.send( ... )
	return skynet.send("CALCULATOR", "lua", ...)
end


local function start_websocket_server(protocol, port)
    local handle = {}
    local conn_map = {}

    function handle.connect(fd)
        local conn = {
            type = "websocket",
            ip = websocket.addrinfo(fd):match("(.+):(%d+)"),
            send = function (msg)
                websocket.write(fd, json.encode(msg))
            end,
            close = function ()
                websocket.close(fd)
            end
        }

        conn_map[fd] = conn
        gate.connect(conn)
    end

    function handle.handshake(fd, header, url)
    end

    function handle.message(fd, msg, msg_type)
        conn_map[fd].message(json.decode(msg))
    end

    function handle.ping(fd)
    end

    function handle.pong(fd)
    end

    function handle.close(fd, code, reason)
        conn_map[fd].disconnect()
        conn_map[fd] = nil
        skynet.error("ws close from: " .. tostring(fd), code, reason)
    end

    function handle.error(fd)
        skynet.error("ws error from: " .. tostring(fd))
    end

    local id = socket.listen("0.0.0.0", port)
    skynet.error(string.format("Listen at %s://0.0.0.0:%s", protocol, port))
    socket.start(id, function(id, addr)
        -- print(string.format("accept client socket_id: %s addr:%s", id, addr))
        local ok, err = websocket.accept(id, handle, protocol, addr)
        if not ok then
            print(err)
        end
    end)
end


skynet.start(function ()
    db("start")
    skynet.fork(start_websocket_server, "ws", 8888)
end)