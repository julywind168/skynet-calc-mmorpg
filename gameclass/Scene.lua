local calc = require "skynet.calc"
local gamex = require "game.extend"

--[[
	id = "main"
	width = 1024
	height = 768
	players = {}
]]
local Scene = {}

function Scene:init()
	self.players = {}
end


function Scene:sync_position(pid, position)
	local position = self:find_player(pid):update_position(position)
	self:broadcast{
		cmd = "scene_sync_position",
		pid = pid,
		position = position
	}
end


function Scene:join(p)
	self:log(string.format("Player['%s'] joined", p.id))
	dump(p)
	self:broadcast{
		cmd = "scene_player_joined",
		p = p:info()
	}
	table.insert(self.players, p)
	return self:info()
end


function Scene:find_player(pid)
	for i,p in ipairs(self.players) do
		if p.id == pid then
			return p
		end
	end
end


function Scene:broadcast(msg)
	local push = gamex:newpush(msg)

	for i,p in ipairs(self.players) do
		push(p.id)
	end
end

function Scene:info()
	local scene = {players = {}}

	for i,p in ipairs(self.players) do
		scene.players[i] = p:info()
	end

	return scene
end


function Scene:log(...)
	calc.error(string.format("Scene[%s]", self.id), ...)
end

return Scene