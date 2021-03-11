class 'PrintLibrary'

function PrintLibrary:Print(instance, str, fields, inner)
	
	if str == nil then
		str = "instance"
	end
	if fields == nil then
		fields = instance.typeInfo.fields
		instance = _G[instance.typeInfo.name](instance)
		print("-- " .. instance.typeInfo.name)
		print(str .. " = " .. instance.typeInfo.name .. "()")
	end
	
	for i,field in pairs(fields) do
		-- fixes for VEXT
		local fieldName = field.name:gsub("^%u", string.lower)
		if field.typeInfo.name == "Vec3" and fieldName == "right" then
			fieldName = "left"
		elseif fieldName == "in" then
			fieldName = "inValue"
		elseif fieldName == "end" then
			fieldName = "endValue"
		elseif fieldName == "fLIRValue" then
			fieldName = "flirValue"
		elseif fieldName == "fLIRKeyColor" then
			fieldName = "flirKeyColor"
		elseif fieldName == "fLIRKeyColor" then
			fieldName = "flirKeyColor"
		elseif fieldName == "uIParts" then
			fieldName = "uiParts"
		end
		
		-- nil check
		if instance[fieldName] == nil then
			print(str .. "." .. fieldName .. " = nil")
			goto endOfLoop
		end
		
		-- casting
		local castedInstance = instance[fieldName]
		if type(castedInstance) == "userdata" and not field.typeInfo.array then
			if castedInstance.typeInfo.name == "" then
				castedInstance = _G[field.typeInfo.name](castedInstance)
			else
				castedInstance = _G[castedInstance.typeInfo.name](castedInstance)
			end
		end
		
		-- array
		if field.typeInfo.array then
			for j,_ in pairs(castedInstance) do
				if type(castedInstance[j]) == "number" then
					print(str .. "." .. fieldName .. ":add(" .. castedInstance[j] .. ")")
				else
					local castedArrayInstance = castedInstance[j]
					if type(castedArrayInstance) == "userdata" then
						if castedArrayInstance.typeInfo.name ~= "" then
							if castedArrayInstance.instanceGuid ~= nil then
								if castedArrayInstance.partitionGuid ~= nil then
									print(str .. "." .. fieldName .. ":add(" .. castedArrayInstance.typeInfo.name .. "(ResourceManager:FindInstanceByGuid(Guid('" .. castedArrayInstance.partitionGuid:ToString('D') .. "'), Guid('" .. castedArrayInstance.instanceGuid:ToString('D') .. "'))))")
								elseif castedArrayInstance.partition ~= nil and castedArrayInstance.partition.guid ~= nil then
									print(str .. "." .. fieldName .. ":add(" .. castedArrayInstance.typeInfo.name .. "(ResourceManager:FindInstanceByGuid(Guid('" .. castedArrayInstance.partition.guid:ToString('D') .. "'), Guid('" .. castedArrayInstance.instanceGuid:ToString('D') .. "'))))")
								else
									print(str .. "." .. fieldName .. ":add(" .. castedArrayInstance.typeInfo.name .. "(ResourceManager:SearchInstanceByGuid(Guid('" .. castedArrayInstance.instanceGuid:ToString('D') .. "'))))")
								end
							else
								print(str .. "." .. fieldName .. ":add(" .. castedArrayInstance.typeInfo.name .. "())")
								castedArrayInstance = _G[castedArrayInstance.typeInfo.name](castedArrayInstance)
								self:Print(castedArrayInstance, str .. "." .. fieldName .. "[" .. j .. "]", castedArrayInstance.typeInfo.fields)
							end
						else
							self:TransformPrintArray(castedArrayInstance, str .. "." .. fieldName, castedArrayInstance.__type.name:match('[^:]+$'))
						end
					end
				end
			end
		
		-- string
		elseif field.typeInfo.name == "CString" then
			if castedInstance == "" then
				print(str .. '.' .. fieldName .. ' = nil')
			else
				print(str .. '.' .. fieldName .. ' = "' .. tostring(castedInstance) .. '"')
			end
			
		-- number (int/ float), boolean
		elseif field.typeInfo.name == "Boolean" 
		or field.typeInfo.name == "Float32" 
		or field.typeInfo.name == "Int8" 
		or field.typeInfo.name == "Int32" 
		or field.typeInfo.name == "Uint32" 
		or field.typeInfo.name == "Uint16" then 
			print(str .. "." .. fieldName .. " = " .. tostring(castedInstance))
		
		-- enum
		elseif field.typeInfo.enum then
			if #field.typeInfo.fields >= 1 then
				local needMatch = true
				for j,innerField in pairs(field.typeInfo.fields)do
					if _G[field.typeInfo.name][innerField.name] == castedInstance then
						print(str .. "." .. fieldName .. " = " .. field.typeInfo.name .. "." .. innerField.name)
						needMatch = false
						break
					end
				end
				if needMatch then
					error("ERROR: ENUM NO MATCH FOUND")
				end
			else
				error("ERROR: ENUM WITHOUT FIELD")
			end
	
		-- DataContainer
		elseif type(castedInstance) == "userdata" then
			if castedInstance.typeInfo.name == "" then
				if castedInstance.instanceGuid ~= nil then
					if castedInstance.partitionGuid ~= nil then
						print(str .. "." .. fieldName .. " = " .. field.typeInfo.name .. "(ResourceManager:FindInstanceByGuid(Guid('" .. castedInstance.partitionGuid:ToString('D') .. "'), Guid('" .. castedInstance.instanceGuid:ToString('D') .. "')))")
					elseif castedInstance.partition ~= nil and castedInstance.partition.guid ~= nil then
						print(str .. "." .. fieldName .. " = " .. field.typeInfo.name .. "(ResourceManager:FindInstanceByGuid(Guid('" .. castedInstance.partition.guid:ToString('D') .. "'), Guid('" .. castedInstance.instanceGuid:ToString('D') .. "')))")
					else
						print(str .. "." .. fieldName .. " = " .. field.typeInfo.name .. "(ResourceManager:SearchInstanceByGuid(Guid('" .. castedInstance.instanceGuid:ToString('D') .. "')))")
					end
				else
					-- Better Vec2, Vec3, Vec4, LinearTransform and AxisAlignedBox prints
					if field.typeInfo.name == "Vec2" 
					or field.typeInfo.name == "Vec3" 
					or field.typeInfo.name == "Vec4" 
					or field.typeInfo.name == "LinearTransform" 
					or field.typeInfo.name == "AxisAlignedBox" then
						self:TransformPrint(castedInstance, str .. "." .. fieldName, field.typeInfo.name)
						goto endOfLoop
					end
					print(str .. "." .. fieldName .. " = " .. field.typeInfo.name .. "()")
					self:Print(castedInstance, str .. "." .. fieldName, field.typeInfo.fields)
				end
			else
				if castedInstance.instanceGuid ~= nil then
					if castedInstance.partitionGuid ~= nil then
						print(str .. "." .. fieldName .. " = " .. castedInstance.typeInfo.name .. "(ResourceManager:FindInstanceByGuid(Guid('" .. castedInstance.partitionGuid:ToString('D') .. "'), Guid('" .. castedInstance.instanceGuid:ToString('D') .. "')))")
					elseif castedInstance.partition ~= nil and castedInstance.partition.guid ~= nil then
						print(str .. "." .. fieldName .. " = " .. castedInstance.typeInfo.name .. "(ResourceManager:FindInstanceByGuid(Guid('" .. castedInstance.partition.guid:ToString('D') .. "'), Guid('" .. castedInstance.instanceGuid:ToString('D') .. "')))")
					else
						print(str .. "." .. fieldName .. " = " .. castedInstance.typeInfo.name .. "(ResourceManager:SearchInstanceByGuid(Guid('" .. castedInstance.instanceGuid:ToString('D') .. "')))")
					end
				else
					-- Better Vec2, Vec3, Vec4, LinearTransform and AxisAlignedBox prints
					if castedInstance.typeInfo.name == "Vec2" 
					or castedInstance.typeInfo.name == "Vec3" 
					or castedInstance.typeInfo.name == "Vec4" 
					or castedInstance.typeInfo.name == "LinearTransform" 
					or castedInstance.typeInfo.name == "AxisAlignedBox" then
						self:TransformPrint(castedInstance, str .. "." .. fieldName, castedInstance.typeInfo.name)
						goto endOfLoop
					end
					print(str .. "." .. fieldName .. " = " .. castedInstance.typeInfo.name .. "()")
					self:Print(castedInstance, str .. "." .. fieldName, castedInstance.typeInfo.fields)
				end
			end
		else
			error("well, this wasn't supposed to happen")
		end
		
		::endOfLoop::
	end
	
	-- Handle child types
	if inner == nil then
		inner = 0
	end
	local super = instance.typeInfo.super
	for i=1, inner do
		if super and super.name ~= "DataContainer" then
			super = super.super
		end
	end
	if super and super.name ~= "DataContainer" then
		print("-- " .. super.name)
		self:Print(instance, str, super.fields, inner + 1)
	end	
end

function PrintLibrary:TransformPrint(instance, str, typeInfoName)
	instance = _G[typeInfoName](instance)
	
	-- Vec2
	if typeInfoName == "Vec2" then
		print(str .. " = Vec2" .. tostring(instance))
	
	-- Vec3
	elseif typeInfoName == "Vec3" then
		print(str .. " = Vec3" .. tostring(instance))
	
	-- Vec4
	elseif typeInfoName == "Vec4" then
		print(str .. " = Vec4" .. tostring(instance))
	
	-- AxisAlignedBox
	elseif typeInfoName == "AxisAlignedBox" then
		print(str .. " = AxisAlignedBox(Vec3" .. tostring(instance.min) .. ", Vec3" .. tostring(instance.max) .. ")")
	
	-- LinearTransform
	elseif typeInfoName == "LinearTransform" then
		print(str .. " = LinearTransform(Vec3" .. tostring(instance.left) .. ", Vec3" .. tostring(instance.up) .. ", Vec3" .. tostring(instance.forward) .. ", Vec3" .. tostring(instance.trans) .. ")")
	
	-- Error
	else
		print("ERROR: userdata without typeInformation name: " .. str)
	end
end

function PrintLibrary:TransformPrintArray(instance, str, typeInfoName)
	instance = _G[typeInfoName](instance)
	
	-- Vec2
	if typeInfoName == "Vec2" then
		print(str .. ":add(Vec2" .. tostring(instance) .. ")")
	
	-- Vec3
	elseif typeInfoName == "Vec3" then
		print(str .. ":add(Vec3" .. tostring(instance) .. ")")
	
	-- Vec4
	elseif typeInfoName == "Vec4" then
		print(str .. ":add(Vec4" .. tostring(instance) .. ")")
	
	-- AxisAlignedBox
	elseif typeInfoName == "AxisAlignedBox" then
		print(str .. ":add(AxisAlignedBox(Vec3" .. tostring(instance.min) .. ", Vec3" .. tostring(instance.max) .. "))")
	
	-- LinearTransform
	elseif typeInfoName == "LinearTransform" then
		print(str .. ":add(LinearTransform(Vec3" .. tostring(instance.left) .. ", Vec3" .. tostring(instance.up) .. ", Vec3" .. tostring(instance.forward) .. ", Vec3" .. tostring(instance.trans) .. "))")
	
	-- Error
	else
		print("ERROR: array without typeInformation name: " .. str)
	end
end

return PrintLibrary()