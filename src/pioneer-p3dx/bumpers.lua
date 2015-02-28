-- BUMPERS

if (sim_call_type==sim_childscriptcall_initialization) then
	-- objects (sensors) and names associated with this sensor unit
	objHandle=simGetObjectAssociatedWithScript(sim_handle_self)
	objName=simGetObjectName(objHandle)
	objChilds=simGetObjectsInTree(objHandle, sim_object_proximitysensor_type)

	-- bumpers in this sensor unit
	bumper_handlers={}
	signal_names={}
	
	-- init publishers for each bumpers and save relevant references to sensors
	for i=1,#objChilds do
		sensorHandle=objChilds[i]
		sensorName=simGetObjectName(sensorHandle)
		bumper_handlers[i]=sensorHandle
		signal_names[i]=sensorName .. 'Sense'

		-- names for ROS must be sanitized, 
		-- multiple instance will be reindexed obj#0 -> i1_obj; obj -> i0_obj
		if sensorName:match('#(%d+)$') then
			rosName = 'i' .. tonumber(sensorName:match('#(%d+)$')) + 1 .. '_' .. sensorName:gsub('#%d+$', '')
		else
			rosName = 'i0_' .. sensorName
		end

		-- enable publisher for each bumper
		simExtROS_enablePublisher(rosName, 1, simros_strmcmd_get_integer_signal, -1, -1, signal_names[i])
	end
end

if (sim_call_type==sim_childscriptcall_sensing) then
	-- push data for each bumper
	for i=1,#bumper_handlers do
		res,dist=simReadProximitySensor(bumper_handlers[i])
		if (res>0) then
			collision=1
		else
			collision=0
		end
		simSetIntegerSignal(signal_names[i], collision)
	end
end

if (sim_call_type==sim_childscriptcall_cleanup) then
end