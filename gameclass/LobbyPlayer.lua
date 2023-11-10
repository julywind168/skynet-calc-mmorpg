local db = require "game.extend".db

local LobbyPlayer = {}

function LobbyPlayer:sign()
	self.gold = self.gold + 100

	db.player.patch({id = self.id}, {gold = self.gold})

	return {ok = true}
end





return LobbyPlayer