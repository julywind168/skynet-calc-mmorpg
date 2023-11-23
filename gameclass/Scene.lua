local calc = require "skynet.calc"
local gamex = require "game.extend"
local conf = require "conf"
local SwordType = require "game.enums".SwordType
local rect_circle_intersect = require "game.utils.rect_circle_intersect"


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


function Scene:_get_hitbox_center(p, angle, sword)
	local c = {x = p.x, y = p.y}
	local a = math.rad(angle)
	c.x = c.x + sword.half_diagonal * math.cos(a)
	c.y = c.y + sword.half_diagonal * math.sin(a)
	return c
end


function Scene:sync_attack(pid, type, angle)
	local hit_players = {}

	local p = self:find_player(pid)
	local sword = conf.swords[type]
	local c = self:_get_hitbox_center(p, angle, sword)
	local h = sword.half_length

	for _,other in ipairs(self.players) do
		if other.id ~= pid and other.hp > 0 then
			if rect_circle_intersect(c, h, angle, other, conf.avatar_radius) then
				local damage = math.min(sword.damage, other.hp)

				other:sub_hp(damage)
				table.insert(hit_players, {
					id = other.id,
					damage = damage,
					dead = other.hp == 0
				})
			end
		end
	end

	self:broadcast{
		cmd = "scene_sync_attack",
		pid = pid,
		type = type,
		angle = angle,
		hit_players = hit_players
	}
end


function Scene:sync_position(pid, position)
	local position = self:find_player(pid):update_position(position)
	self:broadcast{
		cmd = "scene_sync_position",
		pid = pid,
		position = position
	}
end


function Scene:revive(pid)
	local p = self:find_player(pid)
	if p then
		p:revive()
		self:broadcast {
			cmd = "scene_player_revived",
			pid = pid
		}
	end
end


function Scene:join(p)
	self:log(string.format("Player['%s'] joined", p.id))
	-- dump(p)
	self:broadcast{
		cmd = "scene_player_joined",
		p = p:info()
	}
	table.insert(self.players, p)
	return self:info()
end

function Scene:leave(pid)
	local p, i = self:find_player(pid)

	if p then
		table.remove(self.players, i)
		self:broadcast {
			cmd = "scene_player_leaved",
			pid = pid
		}
		p.base.scene.x = p.x
		p.base.scene.y = p.y
		p.base.scene.hp = p.hp
		return p.base.scene
	end
end


function Scene:find_player(pid)
	for i,p in ipairs(self.players) do
		if p.id == pid then
			return p, i
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