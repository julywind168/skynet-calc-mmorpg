local avatar = {
	width = 50,
	height = 50
}


local conf = {

	client_delay_logout_time = 1 * 60,

	avatar = avatar,
	avatar_radius = math.sqrt(avatar.width^2 + avatar.height^2),

	swords = {
		-- IceSword
		{
			width = 1234*0.12 + 300 + avatar.height/2,
			height = 393*0.12,
			damage = 10
		},
		-- FireSword
		{
			width = 1221*0.15 + 400 + avatar.height/2,
			height = 1175 * 0.15,
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