-- ULTRASONIC SENSOR

if (sim_call_type==sim_childscriptcall_initialization) then
	-- objects (sensors) and names associated with this sensor unit
	objHandle=simGetObjectAssociatedWithScript(sim_handle_self)
	objName=simGetObjectName(objHandle)
	objChilds=simGetObjectsInTree(objHandle, sim_object_proximitysensor_type)

	-- ultrasonics in this sensor unit
	sensor_handlers={}
	signal_names={}

	-- publish distances for each ultrasonic sensors
	for i=1,#objChilds do
		sensorHandle=objChilds[i]
		sensorName=simGetObjectName(sensorHandle)
		sensor_handlers[i]=sensorHandle
		signal_names[i]=sensorName .. 'Sense'

		-- names for ROS must be sanitized, 
		-- multiple instance will be reindexed obj#0 -> i1_obj; obj -> i0_obj
		if sensorName:match('#(%d+)$') then
			rosName = 'i' .. tonumber(sensorName:match('#(%d+)$')) + 1 .. '_' .. sensorName:gsub('#%d+$', '')
		else
			rosName = 'i0_' .. sensorName
		end

		simExtROS_enablePublisher(rosName, 1, simros_strmcmd_get_float_signal, -1, -1, signal_names[i])
	end
end

if (sim_call_type==sim_childscriptcall_sensing) then
	-- push data for each bumper
	for i=1,#sensor_handlers do
		res,dist=simReadProximitySensor(sensor_handlers[i])
		if (res<1) then -- nothing detected or failed
			dist=0
		end
		simSetFloatSignal(signal_names[i], dist)
	end
end

if (sim_call_type==sim_childscriptcall_cleanup) then
end