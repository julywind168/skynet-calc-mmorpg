local skynet = require "skynet"

local MAX_CACHE_MSG = 256


local function load_player(pid, ip)
	return {
		id = pid,
		gold = 100,
		ip = ip
	}
end


local function auth(msg, ip)
	assert(msg.id and msg.password == "123")
	return true, load_player(msg.id, ip)
end


local function newclient(conn, id, pid)

	local self = {
		connected = true,
		pid = pid,
		msgidx = 0,
		msgcache = {},
		token = string.random_str(8) 		-- for reconnect auth
	}

	function self:update(newconn)
		conn.client = nil
		conn.close()
		conn = newconn
	end

	function self:send(msg)
		self.msgidx = self.msgidx + 1
		self.msgcache[self.msgidx] = msg

		if self.msgidx > MAX_CACHE_MSG then
			self.msgcache[self.msgidx - MAX_CACHE_MSG] = nil
		end

		conn.send(msg)
	end

	function self:disconnect()
		self.connected = false
	end

	return self
end


return function (calc)

	local client_map = {}	-- pid -> client


	local self = {}

	function self.connect(conn)

		conn.verified = false

		local function login(msg)
			local ok, p = auth(msg, conn.ip)
			if ok then
				dump("Login OK", p)
				local old_c = client_map[p.id]
				if old_c then
					-- todo, killout
				end
				
				calc.call("login", p.id, p)

				local c = newclient(conn, id, p.id)
				client_map[p.id] = c

				conn.verified = true
				conn.client = c
				conn.send{ok = true, token = c.token, p = p}
			else
				conn.send{ok = false, err = p}
			end
		end

		local function reconnect(msg)
			local pid = assert(msg.id)
			local msgidx = assert(msg.msgidx)
			local c = client_map[pid]
			if not c then
				conn.send{ok = false}
				return
			end
			if c.token ~= msg.token then
				conn.send{ok = false}
				return
			end
			if c.msgidx - msgidx > MAX_CACHE_MSG or msgidx > c.msgidx then
				conn.send{ok = false}
				return
			end

			c:update(conn)
			conn.verified = true
			conn.client = c

			conn.send{ok = true}
			for i=msgidx+1,c.msgidx do
				conn.send(c.msgcache[i])
			end
		end

		function conn.message(msg)
			if conn.verified == false then
				if msg.cmd == "login" then
					login(msg)
				else
					assert(msg.cmd == "reconnect")
					reconnect(msg)
				end
			else
				-- msg: {session = 1, action = {"playcard", "pid", ...}}

				local c = conn.client

				local session = msg.session
				local action = msg.action

				local r, push = calc.call(table.unpack(action))

				if session > 0 then
					r.session = session
					c:send(r)
				end

				if push then
					for msg,players in pairs(push) do
						for i,pid in ipairs(players) do
							c = client_map[pid]
							if c then
								c:send(msg)
							else
								skynet.error(string.format("Push error, not found player %s", pid))
							end
						end
					end
				end
			end
		end

		function conn.disconnect()
			if conn.client then
				conn.client:disconnect()
			end
		end
	end

	return self
end