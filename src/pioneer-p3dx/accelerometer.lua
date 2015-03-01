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
	simExtROS_enablePublisher(rosName , 1, simros_strmcmd_get_string_signal , -1, -1, objName .. 'Sense')
	
end

if (sim_call_type==sim_childscriptcall_sensing) then
	result,force=simReadForceSensor(forceSensorHandle)
	-- publish accel data for each axis. units: m/s
	if (result>0) then
		accel={force[1]/mass,force[2]/mass,force[3]/mass}
		simSetStringSignal(objName..'Sense',string.format("%.8f",accel[1])..';'..string.format("%.8f",accel[2])..';'..string.format("%.8f",accel[3]))
	end
end 

if (sim_call_type==sim_childscriptcall_cleanup) then 
end 