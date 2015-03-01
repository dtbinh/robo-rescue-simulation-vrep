if (sim_call_type==sim_childscriptcall_initialization) then 
	-- This script handles receiving and publishing Twist msg between ROS and motors in Vrep
	-- This script is only suitable for differential drive robots
	modelHandle=simGetObjectAssociatedWithScript(sim_handle_self)
	objName=simGetObjectName(modelHandle) 
	lmotorHandle=simGetObjectChild(modelHandle,0)
	rmotorHandle=simGetObjectChild(modelHandle,1)
	
	-- names for ROS must be sanitized, 
	-- multiple instance will be reindexed obj#0 -> i1_obj; obj -> i0_obj
	if objName:match('#(%d+)$') then
		rosName = 'i' .. tonumber(objName:match('#(%d+)$')) + 1 .. '_' .. objName:gsub('#%d+$', '')
	else
		rosName = 'i0_' .. objName
	end
	-- Publisher publish StampedTwist_msg and subscriber uses Twist_msg
	simExtROS_enablePublisher(rosName..'P',1,simros_strmcmd_get_twist_status ,modelHandle,-1,'')
	simExtROS_enableSubscriber(rosName..'S',1,simros_strmcmd_set_twist_command ,-1,-1,objName..'Twist')
	WHEEL_HALF_DIST = 200 -- half distance in between wheels of robot
	WHEEL_RADIUS = 93 
end 

if (sim_call_type==sim_childscriptcall_cleanup) then 
 
end 

if (sim_call_type==sim_childscriptcall_actuation) then 
	
	-- load twist data from ROS topic: 6 float values (TWIST ros msg)
	local data=simGetStringSignal(objName..'Twist')
	if (data) then
		local twist_data=simUnpackFloats(data)
		-- (linear_vel - half_distance between wheels* angular vel) / radius of wheel
		local left_speed= (twist_data[1]-WHEEL_HALF_DIST *twist_data[6])/WHEEL_RADIUS  
		local right_speed =(twist_data[1]+WHEEL_HALF_DIST *twist_data[6])/WHEEL_RADIUS
		simSetJointTargetVelocity(lmotorHandle,left_speed)
		simSetJointTargetVelocity(rmotorHandle,right_speed)
	end
end
