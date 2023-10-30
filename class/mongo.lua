local skynet = require "skynet"
local mongo = require "skynet.db.mongo"


return function (conf)

	local client, db

	local function start()
		client = mongo.client(conf)
		db = client[conf.db_name]
		skynet.error(string.format("connect %s success!", tostring(db)))
	end

	local function close()
		client:disconnect()
	end


	local m = {}

	function m.insert_one(coll, doc)
		return db[coll]:safe_insert(doc)
	end

	function m.insert_many(coll, docs)
		return db[coll]:safe_batch_insert(docs)
	end

	function m.delete_one(coll, query)
		return db[coll]:delete(query, 1)
	end

	function m.delete_many(coll, query)
		return db[coll]:delete(query)
	end

	function m.find_one(coll, query, projection)
		return db[coll]:findOne(query, projection)
	end

	function m.find_many(coll, query, projection, sorter, limit, skip)
	    local t = {}
	    local it = db[coll]:find(query, projection)
	    if not it then
	        return t
	    end

        if sorter then
            if #sorter > 0 then
                it = it:sort(table.unpack(sorter))
            else
                it = it:sort(sorter)
            end
        end
    
        if limit then
            it:limit(limit)
            if skip then
                it:skip(skip)
            end
        end
    
        while it:hasNext() do
            table.insert(t, it:next())
        end
    
        return t
	end

	function m.update_one(coll, query, update)
		return db[coll]:safe_update(query, update)
	end

	function m.update_many(coll, query, update)
		return db[coll]:safe_update(query, update, false, true)
	end

	-- Index
	function m.createIndex(coll, ...)
		return db[coll]:createIndex(...)
	end

	function m.dropIndex(coll, ...)
		return db[coll]:dropIndex(...)
	end

	-- Ex
	function m.patch(coll, query, patch)
		return db[coll]:safe_update(query, {["$set"] = patch})
	end

	function m.count(coll, query)
		return db[coll]:find(query):count()
	end

	function m.sum(coll, query, key)
	    local pipeline = {}
	    if query then
	        table.insert(pipeline,{["$match"] = query})
	    end
	   
	    table.insert(pipeline,{["$group"] = {_id = false, [key] = {["$sum"] = "$" .. key}}})
	   
	    local result = db:runCommand("aggregate", coll, "pipeline", pipeline, "cursor", {}, "allowDiskUse", true)

	    if result and result.ok == 1 then
	        if result.cursor and result.cursor.firstBatch then
	            local r = result.cursor.firstBatch[1]
	            return r and r[key] or 0
	        end
	    end
	    return 0
	end


	local cache = {}

	local function collection(coll)
	    local c = cache[coll]
	    if not c then
	        c = setmetatable({}, {__index = setmetatable({}, {__index = function (_, k)
	            return function (...)
	                local f = assert(m[k], k)
	                return f(coll, ...)
	            end
	        end})})
	        cache[coll] = c
	    end
	    return c
	end

	local mt = {}

	function mt.__index(_, coll)
		return collection(coll)
	end

	function mt.__call(_, cmd)
		if cmd == "start" then
			start()
		else
			assert(cmd == "close")
			close()
		end
	end

	return setmetatable({}, mt)
end