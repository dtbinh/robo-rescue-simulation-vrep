-- -- GPS

-- if (sim_call_type==sim_childscriptcall_initialization) then 
-- 	modelHandle=simGetObjectAssociatedWithScript(sim_handle_self)
-- 	objName=simGetObjectName(modelHandle)
-- 	sharp=string.find(objName,'#')
-- 	if (sharp == nil)
-- 		then sharp=nil
-- 		else sharp=sharp-1
-- 		end
-- 	root_name= string.sub(objName,1,sharp)
-- 	if (sharp == nil) 
-- 		then sufix=""
-- 		else sufix= string.sub(objName,sharp+1) end

-- 	ref=simGetObjectHandle(root_name..'_reference'..sufix)
	
	
-- 	gpsCommunicationTube=simTubeOpen(0,objName..simGetNameSuffix(nil),1)

-- 	xShiftAmplitude=0
-- 	yShiftAmplitude=0
-- 	zShiftAmplitude=0
-- 	xShift=0
-- 	yShift=0
-- 	zShift=0
-- end 

-- if (sim_call_type==sim_childscriptcall_sensing) then 
-- 	xNoiseAmplitude=simGetScriptSimulationParameter(sim_handle_self,'xNoiseAmplitude')
-- 	if not xNoiseAmplitude then xNoiseAmplitude=0 end
-- 	if xNoiseAmplitude<0 then xNoiseAmplitude=0 end
-- 	if xNoiseAmplitude>100 then xNoiseAmplitude=100 end
	
-- 	yNoiseAmplitude=simGetScriptSimulationParameter(sim_handle_self,'yNoiseAmplitude')
-- 	if not yNoiseAmplitude then yNoiseAmplitude=0 end
-- 	if yNoiseAmplitude<0 then yNoiseAmplitude=0 end
-- 	if yNoiseAmplitude>100 then yNoiseAmplitude=100 end
	
-- 	zNoiseAmplitude=simGetScriptSimulationParameter(sim_handle_self,'zNoiseAmplitude')
-- 	if not zNoiseAmplitude then zNoiseAmplitude=0 end
-- 	if zNoiseAmplitude<0 then zNoiseAmplitude=0 end
-- 	if zNoiseAmplitude>100 then zNoiseAmplitude=100 end
	
-- 	xShiftAmplitudeN=simGetScriptSimulationParameter(sim_handle_self,'xShiftAmplitude')
-- 	if not xShiftAmplitudeN then xShiftAmplitudeN=0 end
-- 	if xShiftAmplitudeN<0 then xShiftAmplitudeN=0 end
-- 	if xShiftAmplitudeN>100 then xShiftAmplitudeN=100 end
-- 	if (xShiftAmplitudeN~=xShiftAmplitude) then
-- 		xShiftAmplitude=xShiftAmplitudeN
-- 		xShift=2*(math.random()-0.5)*xShiftAmplitude
-- 	end
	
-- 	yShiftAmplitudeN=simGetScriptSimulationParameter(sim_handle_self,'yShiftAmplitude')
-- 	if not yShiftAmplitudeN then yShiftAmplitudeN=0 end
-- 	if yShiftAmplitudeN<0 then yShiftAmplitudeN=0 end
-- 	if yShiftAmplitudeN>100 then yShiftAmplitudeN=100 end
-- 	if (yShiftAmplitudeN~=yShiftAmplitude) then
-- 		yShiftAmplitude=yShiftAmplitudeN
-- 		yShift=2*(math.random()-0.5)*yShiftAmplitude
-- 	end
	
-- 	zShiftAmplitudeN=simGetScriptSimulationParameter(sim_handle_self,'zShiftAmplitude')
-- 	if not zShiftAmplitudeN then zShiftAmplitudeN=0 end
-- 	if zShiftAmplitudeN<0 then zShiftAmplitudeN=0 end
-- 	if zShiftAmplitudeN>100 then zShiftAmplitudeN=100 end
-- 	if (zShiftAmplitudeN~=zShiftAmplitude) then
-- 		zShiftAmplitude=zShiftAmplitudeN
-- 		zShift=2*(math.random()-0.5)*zShiftAmplitude
-- 	end
	
-- 	objectAbsolutePosition=simGetObjectPosition(ref,-1)
	
-- 	-- Now add some noise to make it more realistic:
-- 	objectAbsolutePosition[1]=objectAbsolutePosition[1]+2*(math.random()-0.5)*xNoiseAmplitude+xShift
-- 	objectAbsolutePosition[2]=objectAbsolutePosition[2]+2*(math.random()-0.5)*yNoiseAmplitude+yShift
-- 	objectAbsolutePosition[3]=objectAbsolutePosition[3]+2*(math.random()-0.5)*zNoiseAmplitude+zShift
	
-- 	simTubeWrite(gpsCommunicationTube,simPackFloats(objectAbsolutePosition))
-- 	simSetStringSignal('mySignal',simPackFloats(objectAbsolutePosition))
	
-- 	-- To read data from this GPS in another script, use following code:
-- 	--
-- 	-- gpsCommunicationTube=simTubeOpen(0,'gpsData'..simGetNameSuffix(nil),1) -- put this in the initialization phase
-- 	-- data=simTubeRead(gpsCommunicationTube)
-- 	-- if (data) then
-- 	--     gpsPosition=simUnpackFloats(data)
-- 	-- end
-- 	--
-- 	-- If the script in which you read the gps has a different suffix than the GPS suffix,
-- 	-- then you will have to slightly adjust the code, e.g.:
-- 	-- gpsCommunicationTube=simTubeOpen(0,'gpsData#') -- if the GPS script has no suffix
-- 	-- or
-- 	-- gpsCommunicationTube=simTubeOpen(0,'gpsData#0') -- if the GPS script has a suffix 0
-- 	-- or
-- 	-- gpsCommunicationTube=simTubeOpen(0,'gpsData#1') -- if the GPS script has a suffix 1
-- 	-- etc.
-- 	--
-- 	--
-- 	-- You can of course also use global variables (not elegant and not scalable), e.g.:
-- 	-- In the GPS script:
-- 	-- simSetFloatSignal('gpsX',objectAbsolutePosition[1])
-- 	-- simSetFloatSignal('gpsY',objectAbsolutePosition[2])
-- 	-- simSetFloatSignal('gpsZ',objectAbsolutePosition[3])
-- 	--
-- 	-- And in the script that needs the data:
-- 	-- positionX=simGetFloatSignal('gpsX')
-- 	-- positionY=simGetFloatSignal('gpsY')
-- 	-- positionZ=simGetFloatSignal('gpsZ')
-- 	--
-- 	-- In addition to that, there are many other ways to have 2 scripts exchange data. Check the documentation for more details
-- end 

-- if (sim_call_type==sim_childscriptcall_cleanup) then 
-- end 