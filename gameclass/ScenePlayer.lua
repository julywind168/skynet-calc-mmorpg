local calc = require "skynet.calc"


--[[
{
	id = "ID"
	rtt = 20
	base = *LobbyPlayer
	x = 0
	y = 0
}
]]

local ScenePlayer = {}


-- init: {rtt = 20, base = *LobbyPlayer}
function ScenePlayer:init()
	self.id = self.base.id
	self.x = self.base.scene.x
	self.y = self.base.scene.y

	calc.error("ScenePlayer init", self.id)

	return self
end


--[[
	position: {
		x = 0,
		y = 0,
		speed: 0,
		direction: (x,y)
	}
]]
function ScenePlayer:update_position(position)
	local position = self:guess(position)
	self.x = position.x
	self.y = position.y
	return position
end

-- 根据 rtt 预测当前的位置
function ScenePlayer:guess(position)
	position.x = position.x + position.direction.x * position.speed * self.rtt/1000/2
	position.y = position.y + position.direction.y * position.speed * self.rtt/1000/2
	return position
end


function ScenePlayer:info()
	return {
		id = self.id,
		x = self.x,
		y = self.y
	}
end


return ScenePlayer