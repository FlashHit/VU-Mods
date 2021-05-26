ResourceManager:RegisterInstanceLoadHandler(Guid('F256E142-C9D8-4BFE-985B-3960B9E9D189'), Guid('705967EE-66D3-4440-88B9-FEEF77F53E77'), function(p_Instance)
	p_Instance = VeniceSoldierHealthModuleData(p_Instance)
	p_Instance:MakeWritable()
	p_Instance.immortalTimeAfterSpawn = 0
end)
