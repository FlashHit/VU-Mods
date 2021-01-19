ResourceManager:RegisterInstanceLoadHandler(Guid('16E67C40-1F23-11E0-B41E-A8C2B4724703'), Guid('2B2F3FDF-0049-7EB0-5DA2-E7F063E5A0E0'), function(instance)
	instance = UIPostProcessComponentData(instance)
	instance:MakeWritable()
	instance.enabled = false
end)

ResourceManager:RegisterInstanceLoadHandler(Guid('61DCFC5E-CFD3-11E0-810E-8F1B6871502B'), Guid('262D171E-93AC-F6A7-F53C-2DA0A9EB6858'), function(instance)
	instance = UIRenderCompData(instance)
	instance:MakeWritable()
	instance.alphaMax  = 0.0
	--instance.bgTexture1 = nil
	--instance.bgTexture2 = nil
end)

ResourceManager:RegisterInstanceLoadHandler(Guid('3A3E5533-4B2A-11E0-A20D-FE03F1AD0E2F'), Guid('9CDAC6C3-9D3E-48F1-B8D9-737DB28AE936'), function(instance)
	instance = ColorCorrectionComponentData(instance)
	instance:MakeWritable()
	instance.excluded = true
	--[[instance.brightness = Vec3(1, 1, 1)
	instance.contrast = Vec3(1, 1, 1)
	instance.saturation = Vec3(1, 1, 1)]]
end)