require 'MCOMEvents'
--[[
Events:Subscribe('MCOM:Armed', function(p_Player)
	print("MCOM:Armed by " .. p_Player.name)
end)
Events:Subscribe('MCOM:Disarmed', function(p_Player)
	print("MCOM:Disarmed by " .. p_Player.name)
end)
Events:Subscribe('MCOM:Destroyed', function(p_Player)
	print("MCOM:Destroyed by " .. p_Player.name)
end)]]
