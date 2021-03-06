-- LASER SCANNER

function to_rad(e)
	return e * (math.pi/180)
end

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
	-- must be in [5, 180], in deg
	scanningAngle=to_rad(tonumber(simGetScriptSimulationParameter(sim_handle_self,"scanningAngle")))
	-- must be in [0.1, 5]
	scanningDensity=tonumber(simGetScriptSimulationParameter(sim_handle_self,"scanningDensity"))
	values={}
	
	p = 0 - scanningAngle/2 -- 0 is forward
	stepSize = (math.pi/(180 * scanningDensity)) -- do #density scans for each 1 deg = PI/180 rad
	pts = scanningAngle * (1/stepSize) + 1 -- #scans

	for i=0,pts,1 do
		simSetJointPosition(jointHandle, p)
		p = p + stepSize
		r,dist = simHandleProximitySensor(laserHandle) -- pt is RELATIVE to the rotating laser beam!
		if r>0 then
			table.insert(values, dist)
		else
			table.insert(values, -1) -- measurent unsuccessful or out of range
		end
	end
	
	-- ros values are in radians
	table.insert(values, 0) -- min angle
	table.insert(values, scanningAngle) -- max angle
	table.insert(values, stepSize)

	simSetStringSignal(objName .. 'Sense', simPackFloats(values))
end 

if (sim_call_type==sim_childscriptcall_cleanup) then 
end 