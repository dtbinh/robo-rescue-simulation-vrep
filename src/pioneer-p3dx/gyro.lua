-- GYRO SENSOR

if (sim_call_type==sim_childscriptcall_initialization) then 
	-- objects (sensors) and names associated with this sensor unit
	objHandle=simGetObjectAssociatedWithScript(sim_handle_self)
	objName=simGetObjectName(objHandle)
	objChilds=simGetObjectsInTree(objHandle, sim_object_dummy_type)

	-- names for ROS must be sanitized, 
	-- multiple instance will be reindexed obj#0 -> i1_obj; obj -> i0_obj
	if objName:match('#(%d+)$') then
		rosName = 'i' .. tonumber(objName:match('#(%d+)$')) + 1 .. '_' .. objName:gsub('#%d+$', '')
	else
		rosName = 'i0_' .. objName
	end
	
	-- init values for transformation
	sensorReferenceHandle=objChilds[1] -- gyro reference (dummy)
	oldTransformationMatrix=simGetObjectMatrix(sensorReferenceHandle,-1)
	lastTime=simGetSimulationTime()

	-- publish for all 3 axes
	simExtROS_enablePublisher(rosName .. 'X', 1, simros_strmcmd_get_float_signal, -1, -1, objName .. 'SenseX')
	simExtROS_enablePublisher(rosName .. 'Y', 1, simros_strmcmd_get_float_signal, -1, -1, objName .. 'SenseY')
	simExtROS_enablePublisher(rosName .. 'Z', 1, simros_strmcmd_get_float_signal, -1, -1, objName .. 'SenseZ')
end 

if (sim_call_type==sim_childscriptcall_sensing) then
	-- quite a calculation
	local transformationMatrix=simGetObjectMatrix(sensorReferenceHandle,-1)
	local oldInverse=simGetInvertedMatrix(oldTransformationMatrix)
	local m=simMultiplyMatrices(oldInverse,transformationMatrix)
	local euler=simGetEulerAnglesFromMatrix(m)
	local currentTime=simGetSimulationTime()
	local gyro={0,0,0}
	local dt=currentTime-lastTime
	if (dt~=0) then
		-- gyroscop data (what units?)
		gyro={euler[1]/dt, euler[2]/dt, euler[3]/dt}
	end
	
	-- push values for all axes
	simSetFloatSignal(objName .. 'SenseX', gyro[1])
	simSetFloatSignal(objName .. 'SenseY', gyro[2])
	simSetFloatSignal(objName .. 'SenseZ', gyro[3])
	
	-- data for next round
	oldTransformationMatrix=simCopyMatrix(transformationMatrix)
	lastTime=currentTime
end 

if (sim_call_type==sim_childscriptcall_cleanup) then 
end 
