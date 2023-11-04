function ENUM(t)
	for i,v in ipairs(t) do
		t[v] = i
	end
	return t
end