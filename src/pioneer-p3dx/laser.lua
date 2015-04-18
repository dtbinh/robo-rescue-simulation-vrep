-- LASER SCANNER

if (sim_call_type==sim_childscriptcall_initialization) then 
	-- objects (sensors) and names associated with this sensor unit
	objHandle=simGetObjectAssociatedWithScript(sim_handle_self)
	objName=simGetObjectName(objHandle)
	objChilds=simGetObjectsInTree(objHandle, sim_object_joint_type)

	-- names for ROS must be sanitized, 
	-- multiple instance will be reindexed obj#0 -> i1_obj; obj -> i0_obj
	if objName:match('#(%d+)$') then
		rosName = 'i' .. tonumber(objName:match('#(%d+)$')) + 1 .. '_' .. objName:gsub('#%d+$', '')
	else
		rosName = 'i0_' .. objName
	end

	jointHandle=objChilds[1] -- joint on laser box
	jointChilds=simGetObjectsInTree(objHandle, sim_object_proximitysensor_type)
	laserHandle=jointChilds[1] -- laser sensor on joint

	simExtROS_enablePublisher(rosName, 1, simros_strmcmd_get_laser_scanner_data, objHandle, -1, objName .. 'Sense')
end 

if (sim_call_type==sim_childscriptcall_sensing) then 
	-- must be in [5, 180]
	scanningAngle=tonumber(simGetScriptSimulationParameter(sim_handle_self,"scanningAngle"))
	-- must be in [0.1, 5]
	scanningDensity=tonumber(simGetScriptSimulationParameter(sim_handle_self,"scanningDensity"))
	values={}
	
	pts=scanningAngle*scanningDensity+1
	p=-scanningAngle*math.pi/360
	stepSize=math.pi/(scanningDensity*180)
	modelInverseMatrix=simGetInvertedMatrix(simGetObjectMatrix(objHandle,-1))
	for i=0,pts,1 do
		simSetJointPosition(jointHandle,p)
		p=p+stepSize
		r,dist=simHandleProximitySensor(laserHandle) -- pt is RELATIVE to te rotating laser beam!
		if r>0 then
			table.insert(values, dist)
		else
			table.insert(values, -1) -- measurent unsuccessful or out of range
		end
	end
	
	table.insert(values, 0) -- min angle
	table.insert(values, scanningAngle) -- max angle
	table.insert(values, stepSize)
	simSetStringSignal(objName .. 'Sense', simPackFloats(values))
end 

if (sim_call_type==sim_childscriptcall_cleanup) then 
end 