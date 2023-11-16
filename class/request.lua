return function (db, calc)


	local request = {}


	function request:heartbeat()
		return {ok = true}
	end



	return request
end