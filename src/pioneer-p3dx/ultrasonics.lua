-- ULTRASONIC SENSOR

if (sim_call_type==sim_childscriptcall_initialization) then
	-- objects (sensors) and names associated with this sensor unit
	objHandle=simGetObjectAssociatedWithScript(sim_handle_self)
	objName=simGetObjectName(objHandle)
	objChilds=simGetObjectsInTree(objHandle, sim_object_proximitysensor_type)

	-- publish distances for each ultrasonic sensors
	for i=1,#objChilds do
		sensorHandle=objChilds[i]
		sensorName=simGetObjectName(sensorHandle)

		-- names for ROS must be sanitized, 
		-- multiple instance will be reindexed obj#0 -> i1_obj; obj -> i0_obj
		if sensorName:match('#(%d+)$') then
			rosName = 'i' .. tonumber(sensorName:match('#(%d+)$')) + 1 .. '_' .. sensorName:gsub('#%d+$', '')
		else
			rosName = 'i0_' .. sensorName
		end

		simExtROS_enablePublisher(rosName, 1, simros_strmcmd_read_proximity_sensor, sensorHandle, -1, '')
	end
end

if (sim_call_type==sim_childscriptcall_sensing) then
end

if (sim_call_type==sim_childscriptcall_cleanup) then
end