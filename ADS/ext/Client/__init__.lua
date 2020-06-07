print("Initializing ADS FOV and Sensibility Mod")
local customvalue = 40
local customvalue2 = 40
local customsensvalue = 0.5
local customsensvalue2 = 0.5
local fov = nil
local fov2 = nil
Events:Subscribe('Partition:Loaded', function(partition)
    for _,instance in pairs(partition.instances) do
		if instance.instanceGuid ==  Guid("5C006FDF-FA1D-4E29-8E21-2ECAB83AC01C") then 
			instance = ZoomLevelData(instance)
			instance:MakeWritable()
			fov = instance
			instance.fieldOfView  = customvalue
			instance.lookSpeedMultiplier  = customsensvalue
			print("fov:"..fov.fieldOfView)  
		end
		if instance.instanceGuid ==  Guid("50887762-21DF-42F5-9740-ECDBCEECC3B4") then 
			instance = ZoomLevelData(instance)
			instance:MakeWritable()
			fov2 = instance
			instance.fieldOfView  = customvalue2
			instance.lookSpeedMultiplier  = customsensvalue2
            print("pistols fov:"..fov2.fieldOfView)
		end
	end
end)
local command = Console:Register('fov', 'Change ADS weapon FOV.', function(args)
	x = tonumber(args[1])
	if tonumber(args[1]) and x >= 40 and x <= 160 then
		fov.fieldOfView  = tonumber(args[1])
		customvalue = tonumber(args[1])
		print("New FOV is "..fov.fieldOfView)
	else
		print("Value must be between 40 and 160")
	end
end)
local command = Console:Register('fov2', 'Change ADS pistol FOV.', function(args)
	x = tonumber(args[1])
	if tonumber(args[1]) and x >= 20 and x <= 160 then
		fov2.fieldOfView  = tonumber(args[1])
		customvalue2 = tonumber(args[1])
		print("New FOV for pistol is "..fov2.fieldOfView)
	else
		print("Value must be between 20 and 160")
	end
end)
local command = Console:Register('fovsens', 'Change ADS weapon sens.', function(args)
	x = tonumber(args[1])
	if tonumber(args[1]) and x >= 0 then
		fov.lookSpeedMultiplier  = tonumber(args[1])
		customsensvalue = tonumber(args[1])
		print("New sens primary is "..fov.lookSpeedMultiplier)
	else
		print("Invalid")
	end
end)
local command = Console:Register('fovsens2', 'Change ADS pistol sens.', function(args)
	x = tonumber(args[1])
	if tonumber(args[1]) and x >= 0 then
		fov2.lookSpeedMultiplier  = tonumber(args[1])
		customsensvalue2 = tonumber(args[1])
		print("New sens for pistol is "..fov2.lookSpeedMultiplier)
	else
		print("Invalid")
	end
end)