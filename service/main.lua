local skynet = require "skynet"

skynet.start(function()

	math.randomseed(tonumber(tostring(os.time()):reverse()))
	skynet.error("=============================================")
	skynet.error(os.date("%Y/%m/%d %H:%M:%S ").." server start")
	skynet.error("=============================================")

	if not skynet.getenv "daemon" then
		local console = skynet.newservice("console")
	end

	skynet.newservice("debug_console", 9999)
	skynet.newservice("calculator", 4)
	skynet.newservice("gate")
	
	skynet.exit()
end)