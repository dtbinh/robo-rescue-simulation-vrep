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
	simExtROS_enablePublisher(rosName , 1, simros_strmcmd_get_string_signal , -1, -1, objName .. 'Sense')
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
		-- gyroscop data units: rad/s
		gyro={euler[1]/dt, euler[2]/dt, euler[3]/dt}
	end
	
	-- push values for all axes
	simSetStringSignal(objName..'Sense',string.format("%.8f",gyro[1])..';'..string.format("%.8f",gyro[2])..';'..string.format("%.8f",gyro[3]))
	
	-- data for next round
	oldTransformationMatrix=simCopyMatrix(transformationMatrix)
	lastTime=currentTime
end 

if (sim_call_type==sim_childscriptcall_cleanup) then 
end 
