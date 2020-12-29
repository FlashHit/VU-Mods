local shots = 0
local hits = 0
Events:Subscribe('Engine:Message', function(message)
	if message.type == -540355792 then
		shots = shots +1
	end
	if message.type == 93974635 then
		hits = hits + 1
	end
end)
Console:Register('Get', 'get your accuracy.', function(args)
	if shots ~= 0 then
		print((hits/shots)*100)
	else
		print("0 shots?")
	end
end)

Console:Register('Reset', 'reset your accuracy.', function(args)
	shots = 0
	hits = 0
	print("Reset done")
end)