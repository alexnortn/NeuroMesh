-- Neuro_Mesh_1.0.ms
-- A script to automate the mesh processing of skeletonized reconstructed Coritcal neurons

if ((NeuroMesh != undefined) and (NeuroMesh.isdisplayed)) do
	(destroyDialog ObjectSeeed_Roll)
	
-- Destroys the rollout if one exists already

rollout NeuroMesh "Select Meshes" -- labels rollout
(
	button but_SObjs "Select Meshes" width:150 height:30 offset:[0,25]
	button but_SWITCH "P R O C E S S" width:150 height:50 offset:[0,10]
	
	label lab_1 "Neuro Mesh 1.0" offset:[0,80]
	label lab_2 "2016 Alex Norton"
	
	local Neurons
	
	on but_SObjs pressed do
	(
		if selection.count < 1
			then messagebox "Please select some objects first." -- checks that 1 or more objects are currently selected
		else
		(
			Neurons = selection as array -- places the currently selected objects in an array when pressed
		)--end else
	)--end action		
	
	on but_SWITCH pressed do
	(
		for i = 1 to Neurons.count do
		(
			rot_x = random 0 360 --> random rotation value x
			rot_y = random 0 360 --> random rotation value y
			rot_z = random 0 360 --> random rotation value z
			
			SetObjectRotation Neurons[i] rot_x rot_y rot_z --> Rotate Object
			SetObjectScale Neurons[i] 0.025 --> Scale Object
			Neurons[i].baseobject = a.baseobject -- switches each object in the array's baseobject with that stored in the variable a 
		)
	)--end action
	
)-- end rollout

createDialog NeuroMesh 200 250

-- Alex Norton
-- Eyewire 2016