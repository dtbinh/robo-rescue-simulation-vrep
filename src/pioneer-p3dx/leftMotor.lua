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
    -- Publisher publish ros joint state msg
    simExtROS_enablePublisher(rosName..'/getState',1,simros_strmcmd_get_joint_state  ,modelHandle,-1,'')
    -- receives std_msg::float64 message from ROS
    simExtROS_enableSubscriber(rosName..'/setVel',1,simros_strmcmd_set_joint_target_velocity  ,modelHandle,-1,'')
    simExtROS_enableSubscriber(rosName..'/setPos',1,simros_strmcmd_set_joint_target_position  ,modelHandle,-1,'')

end


if (sim_call_type==sim_childscriptcall_actuation) then

end


if (sim_call_type==sim_childscriptcall_sensing) then

end


if (sim_call_type==sim_childscriptcall_cleanup) then

end