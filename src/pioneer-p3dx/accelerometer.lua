-- ACCELEROMETER

if (sim_call_type==sim_childscriptcall_initialization) then
	-- objects (sensors) and names associated with this sensor unit
	objHandle=simGetObjectAssociatedWithScript(sim_handle_self)
	objName=simGetObjectName(objHandle)
	objChilds=simGetObjectsInTree(objHandle, sim_object_forcesensor_type)

	-- names for ROS must be sanitized, 
	-- multiple instance will be reindexed obj#0 -> i1_obj; obj -> i0_obj
	if objName:match('#(%d+)$') then
		rosName = 'i' .. tonumber(objName:match('#(%d+)$')) + 1 .. '_' .. objName:gsub('#%d+$', '')
	else
		rosName = 'i0_' .. objName
	end

	-- init data for accel computation
	forceSensorHandle=objChilds[1] -- force sensor of accel meter
	massObjectHandle=simGetObjectChild(forceSensorHandle, 0)
	result,mass=simGetObjectFloatParameter(massObjectHandle,3005)
	
	-- init publishers for all 3 axes
	simExtROS_enablePublisher(rosName .. 'X', 1, simros_strmcmd_get_float_signal, -1, -1, objName .. 'SenseX')
	simExtROS_enablePublisher(rosName .. 'Y', 1, simros_strmcmd_get_float_signal, -1, -1, objName .. 'SenseY')
	simExtROS_enablePublisher(rosName .. 'Z', 1, simros_strmcmd_get_float_signal, -1, -1, objName .. 'SenseZ')
end

if (sim_call_type==sim_childscriptcall_sensing) then
	result,force=simReadForceSensor(forceSensorHandle)
	-- publish accel (what units?) data for each axis
	if (result>0) then
		accel={force[1]/mass,force[2]/mass,force[3]/mass}
		simSetFloatSignal(objName .. 'SenseX', accel[1])
		simSetFloatSignal(objName .. 'SenseY', accel[2])
		simSetFloatSignal(objName .. 'SenseZ', accel[3])
	end
end 

if (sim_call_type==sim_childscriptcall_cleanup) then 
end 