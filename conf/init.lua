local avatar = {
	width = 50,
	height = 50
}


local conf = {

	client_delay_logout_time = 1 * 20,

	avatar = avatar,
	avatar_radius = math.sqrt(avatar.width^2 + avatar.height^2),

	swords = {
		-- IceSword
		{
			width = 393*0.12,
			height = 1234*0.12 + 300 + avatar.height/2,
			damage = 10
		},
		-- FireSword
		{
			width = 1175 * 0.15,
			height = 1221*0.15 + 400 + avatar.height/2,
			damage = 20
		}
	}
}


for i,sword in ipairs(conf.swords) do
	sword.half_length = {
		x = sword.width/2,
		y = sword.height/2
	}
	sword.half_diagonal = math.sqrt(sword.width^2 + sword.height^2)/2
end




return conf