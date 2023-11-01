return function (db, calc)


	local self = {}


	function self.heartbeat(pid)
		return {ok = true}
	end



	return self
end