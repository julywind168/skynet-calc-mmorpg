local skynet = require "skynet"

local calc = {}

function calc.call(...)
	return skynet.call("CALCULATOR", "lua", ...)
end

function calc.send( ... )
	return skynet.send("CALCULATOR", "lua", ...)
end









skynet.start(function ()
	skynet.error "gate start"

	local p = calc.call("login", "PID_888", "127.0.0.1")
	dump(p)

end)