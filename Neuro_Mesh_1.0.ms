-- Neuro_Mesh_1.0.ms
-- A script to automate the mesh processing of skeletonized reconstructed Coritcal neurons



if ((NeuroMesh != undefined) and (NeuroMesh.isdisplayed)) do
	(destroyDialog ObjectSeeed_Roll)
	
-- Destroys the rollout if one exists already

rollout NeuroMesh "Select Meshes" -- labels rollout
(
	button but_SObjs "Select Meshes" width:150 height:30 offset:[0,25]
	button but_SWITCH "P R O C E S S" width:150 height:50 offset:[0,50]
	button but_SWITCH1 "S O M A" width:150 height:50 offset:[0,10]
	button but_SWITCH2 "S Y N A P S E" width:150 height:50 offset:[0,10]
	button but_SWITCH3 "T O G G L E" width:150 height:50 offset:[0,10]
	
	label lab_1 "Neuro Mesh 1.0" offset:[0,50]
	label lab_2 "2016 Alex Norton"
	
	local Meshes
	
	on but_SObjs pressed do
	(
		if selection.count < 1
			then messagebox "Please select some objects first." -- checks that 1 or more objects are currently selected
		else
		(
			Meshes = selection as array -- places the currently selected objects in an array when pressed
			mc = Meshes.count as String
			print ("Selection contains: " + mc + " meshes.")
		)--end else
	)--end action		
	
	fn nTurboSmooth obj itr =
	(
		/*
			TurboSmooth lets you subdivide the geometry while interpolating
			the angles of new faces at corners and edges, and apply a
			single smoothing group to all faces in the object. The effect 
			of TurboSmooth is to round over corners and edges as if they
			had been filed or planed smooth. Use TurboSmooth parameters to 
			control the size and number of new faces, and how they affect 
			the surface of the object.
			-
			Use the TurboSmooth modifier to increase the poly/vertex count
			of a mesh before optimizing, this generally creates a more
			consistent vertex distribution with natural stochasticity.
		*/

		print "Applying TurboSmooth Modifier.."

		modPanel.addModToSelection (TurboSmooth ()) --ui:on
			obj.modifiers[#TurboSmooth].iterations = itr

		print "Complete."
	)

	fn nProOptimizer obj prcnt =
	(
		/*
			The ProOptimizer feature is an optimization tool that helps you 
			reduce the number of vertices (and so the number of faces) in 
			an object while preserving the object’s appearance. Options 
			let you maintain material, mapping, and vertex color information
			in the optimized model.
			-
			Once the model has been subdivided, use ProOptimizer to bring
			the geometry back to a more manageable size.
		*/

		print "Applying ProOptimizer Modifier.."

		modPanel.addModToSelection (ProOptimizer ())
			obj.modifiers[#ProOptimizer].OptimizationMode = 1 -- (0) Crunch Borders (1) Protect Borders (2) Exclude Borders 
			obj.modifiers[#ProOptimizer].VertexPercent = prcnt -- Reduce mesh to 10% original vertex

		print "Complete."
	)
	
	fn runProOptimizer obj = 
	(
		obj.modifiers[#ProOptimizer].Calculate = True -- Run optimization
	)

	fn nRelax obj itr =
	(
		/*
			The Relax modifier changes the apparent surface tension in a mesh
			by moving vertices closer to, or away from, their neighbors. 
			The typical result is that the object gets smoother and a little 
			smaller as the vertices move toward an averaged center point. 
			You can see the most pronounced effects on objects with sharp
			corners and edges.
			-
			Useful with the skeletonization process as it helps to relieve
			stress brought on by the overlapping cylindrical volumes.
		*/

		print "Applying Relax Modifier.."

		modPanel.addModToSelection (Relax ())
			obj.modifiers[#Relax].iterations = itr
			obj.modifiers[#Relax].Relax_Value = 0.5

		print "Complete."
	)
	
	fn addDisplace obj strength =
	(
		/*
			Displace distributes its force through four different gizmos: Planar,
			Cylindrical, Spherical, and Shrink Wrap. Gizmos are also used as 
			mapping coordinates for applying bitmaps. Sphere and Shrink Wrap
			have the same effect when modeling, but differ in the way they map.
		*/
		
		local ut = random 250 1500 -- Random tile parameters
		local vt = random 250 1500
		local wt = random 250 1500
		
		local noiseMap = noise()
				noiseMap.coords.Tiling = [ut,vt,wt] -- Default [1,1,1]
		
		local displaceStrength = random -4 4
				displaceStrength *= strength
		
		local displaceModifier = Displace()
				displaceModifier.lumCenterEnable = true
				displaceModifier.strength = displaceStrength
				displaceModifier.map = noiseMap
				displaceModifier.maptype = 2 -- (0) Planar (1) Cylindrical (2) Spherical (3) Shrink Wrap
		
		addModifier obj displaceModifier
	)

	fn SetObjectRotation obj = -- Parameterize with rx ry rz  if necessary
	(
		-- Reset the object's transformation matrix so that 
		-- it only includes position and scale information. 
		-- Doing this clears out any previous object rotation.
		local translateMat = transMatrix obj.transform.pos
		local scaleMat = scaleMatrix obj.transform.scale
		obj.transform = scaleMat * translateMat
		
		local rx = random 0 360 --> random rotation value x
		local ry = random 0 360 --> random rotation value y
		local rz = random 0 360 --> random rotation value z
	   
		-- Perform each axis rotation individually
		rotate obj (angleaxis rx [1,0,0])
		rotate obj (angleaxis ry [0,1,0])
		rotate obj (angleaxis rz [0,0,1])
	)
	
	fn SetObjectScale obj = -- Parameterize with ratio
	(
		local sx = random 0.85 1.15
		local sy = random 0.85 1.15
		local sz = random 0.85 1.15
		
		local scaleModifier = XForm()
				scaleModifier.Gizmo.scale = [sx,sy,sz]
		
		addModifier obj scaleModifier 
		--scale obj [sx,sy,sz]
	)
	
	fn SetObjectScaleSoma obj ratio = -- Parameterize with ratio
	(
		local scaleModifier = XForm()
				scaleModifier.Gizmo.scale = [ratio,ratio,ratio]
		
		addModifier obj scaleModifier 
		--scale obj [sx,sy,sz]
	)
	
	on but_SWITCH pressed do
	(
		for i = 1 to Meshes.count do
		(
			mesh = Meshes[i]
			
			select mesh -- Select working object

			index = i as String
			mesh_count = Meshes.count as String
			mesh_id = mesh as String
		
			print ("Starting Mesh: " + mesh_id + "\n number:" + index + "|" + mesh_count)

			ConvertTo mesh Editable_Poly -- Make sure we are dealing with Editable Poly
		
			nTurboSmooth mesh 2 		-- Apply TurboSmooth (2)
			nRelax mesh 1					-- Apply Relax (1)
			
			polyop.capHolesByEdge mesh #all 	-- Cap Holes
			polyop.capHolesByFace mesh #all 	-- Cap Holes
			polyop.capHolesByVert mesh #all 	-- Cap Holes
			
			sleep 1

			collapseStack mesh -- Collapse Stack
			
			sleep 1
			
			nProOptimizer mesh 10		-- Apply ProOptimizer (10%)
			runProOptimizer mesh 		-- Run Optimization

			ConvertTo mesh Editable_Poly -- Make sure we are dealing with Editable Poly
			
			print ("Completed " + mesh_id + " " + index)
			
			sleep 1
		)
	)--end action
	
	on but_SWITCH1 pressed do
	(
		for i = 1 to Meshes.count do
		(
			mesh = Meshes[i]
			
			select mesh -- Select working object

			index = i as String
			mesh_count = Meshes.count as String
			mesh_id = mesh as String
		
			print ("Starting Mesh: " + mesh_id + "\n number:" + index + "|" + mesh_count)

			ConvertTo mesh Editable_Poly -- Make sure we are dealing with Editable Poly
		
			addDisplace  mesh 0.01		-- Apply Displacement
			SetObjectRotation mesh 	-- Apply Random Rotation
			SetObjectScale mesh 		-- Apply Random Scaling
		

			--collapseStack mesh -- Collapse Stack

			--ConvertTo mesh Editable_Poly -- Make sure we are dealing with Editable Poly
			
			print ("Completed " + mesh_id + " " + index)
			
			--sleep 1
		)
	)--end action
	
	on but_SWITCH2 pressed do
	(
		for i = 1 to Meshes.count do
		(
			mesh = Meshes[i]
			
			select mesh -- Select working object

			index = i as String
			mesh_count = Meshes.count as String
			mesh_id = mesh as String
		
			print ("Starting Mesh: " + mesh_id + "\n number:" + index + "|" + mesh_count)

			ConvertTo mesh Editable_Poly -- Make sure we are dealing with Editable Poly
		
			addDisplace  mesh 0.01					-- Apply Displacement
			SetObjectRotation mesh 				-- Apply Random Rotation
			SetObjectScaleSoma mesh 0.5 		-- Apply Random Scaling
		

			--collapseStack mesh -- Collapse Stack

			--ConvertTo mesh Editable_Poly -- Make sure we are dealing with Editable Poly
			
			print ("Mesh Complete")
			print "\n"
			
			--sleep 1
		)
	)--end action
	
	on but_SWITCH3 pressed do
	(
		for i = 1 to Meshes.count do
		(
			mesh = Meshes[i]
			
			select mesh -- Select working object

			index = i as String
			mesh_count = Meshes.count as String
			mesh_id = mesh as String
		
			print ("Starting Mesh: " + mesh_id + "\n number:" + index + "|" + mesh_count)
			
			for mod in mesh.modifiers do 		-- For each modifier on stack
			(
				if (mod.enabled == true)
					then
						mod.enabled = false
					else
						mod.enabled = true
				
				print mod.enabled as String
			)
		
			--ConvertTo mesh Editable_Poly -- Make sure we are dealing with Editable Poly
			
			print ("Mesh Complete")
			print "\n"
			
			--sleep 1
		)
	)--end action
	
)-- end rollout

createDialog NeuroMesh 200 450



-- Alex Norton
-- Eyewire 2016