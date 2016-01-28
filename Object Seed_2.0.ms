-- Object Seed Script.ms

-- A script to switch over the base objects of a selection with that of a picked object
-- then generate some random perturbations

if ((ObjectSeed_Roll != undefined) and (ObjectSeed_Roll.isdisplayed)) do
	(destroyDialog ObjectSeeed_Roll)
	
-- Destroys the rollout if one exists already

rollout ObjectSeed_Roll "Switch Base Objects" -- labels rollout
(
		button but_SObjs "Make Global Selection" width:150 height:30 offset:[0,25]
		pickbutton pbt_NBase "Select Base Object" width:150 height:30
		button but_SWITCH "S E E D" width:150 height:50 offset:[0,10]
		
		label lab_1 "Object Seed 2.0" offset:[0,80]
		label lab_2 "2016 Alex Norton"
		
		local MySwitchArray
		local a
		
		on but_SObjs pressed do
		(
			if selection.count < 1
			then messagebox "Please select some objects first." -- checks that 1 or more objects are currently selected
			else
			(
				MySwitchArray = selection as array -- places the currently selected objects in an array when pressed
			)--end else
		)--end action
		
		on pbt_NBase picked NBObject do
		(
			a = NBObject -- stores the picked object in variable a
		)--end action
		
		------------------------------------------------------
		-- Set the given object's rotation to the given values
		------------------------------------------------------
		fn SetObjectRotation obj rx ry rz =
		(
			-- Reset the object's transformation matrix so that 
			-- it only includes position and scale information. 
			-- Doing this clears out any previous object rotation.
			local translateMat = transMatrix obj.transform.pos
			local scaleMat = scaleMatrix obj.transform.scale
			obj.transform = scaleMat * translateMat
		   
			-- Perform each axis rotation individually
			rotate obj (angleaxis rx [1,0,0])
			rotate obj (angleaxis ry [0,1,0])
			rotate obj (angleaxis rz [0,0,1])
		)
		
		------------------------------------------------------
		-- Set the given object's uniform scale to the given value
		------------------------------------------------------
		fn SetObjectScale obj ratio =
		(
			scale obj [ratio,ratio,ratio]
		)
		
		
		
		on but_SWITCH pressed do
		(
			for i = 1 to MySwitchArray.count do
			(
				rot_x = random 0 360 --> random rotation value x
				rot_y = random 0 360 --> random rotation value y
				rot_z = random 0 360 --> random rotation value z
				
				SetObjectRotation MySwitchArray[i] rot_x rot_y rot_z --> Rotate Object
				SetObjectScale MySwitchArray[i] 0.025 --> Scale Object
				MySwitchArray[i].baseobject = a.baseobject -- switches each object in the array's baseobject with that stored in the variable a 
			)
		)--end action
	
)-- end rollout

createDialog ObjectSeed_Roll 200 300

-- That's all folks!!
-- Written by Martin Skinner www.martinskinner.co.uk for use whilst at Sprunt Media, http://www.sprunt-media.net
-- Finished 21/03/2007