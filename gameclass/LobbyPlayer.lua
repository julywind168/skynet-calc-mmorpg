local LobbyPlayer = {}

function LobbyPlayer:sign()
	self.gold = self.gold + 100
	return {ok = true}
end





return LobbyPlayer