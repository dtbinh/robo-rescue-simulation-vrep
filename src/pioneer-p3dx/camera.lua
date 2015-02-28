-- CAMERA

if (sim_call_type==sim_childscriptcall_initialization) then
	-- objects (sensors) and names associated with this sensor unit
	objHandle=simGetObjectAssociatedWithScript(sim_handle_self)
	objName=simGetObjectName(objHandle)
	objChilds=simGetObjectsInTree(objHandle, sim_object_proximitysensor_type)
	
	-- names for ROS must be sanitized, 
	-- multiple instance will be reindexed obj#0 -> i1_obj; obj -> i0_obj
	if objName:match('#(%d+)$') then
		rosName = 'i' .. tonumber(objName:match('#(%d+)$')) + 1 .. '_' .. objName:gsub('#%d+$', '')
	else
		rosName = 'i0_' .. objName
	end

	-- publish to ros
	simExtROS_enablePublisher(rosName, 1, simros_strmcmd_get_vision_sensor_image, objHandle, 0, '')
end

if (sim_call_type==sim_childscriptcall_sensing) then
end

if (sim_call_type==sim_childscriptcall_cleanup) then
end