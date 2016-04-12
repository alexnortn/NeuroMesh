-- Neuro_Mesh_1.0.ms
-- A script to automate the mesh processing of skeletonized reconstructed Coritcal neurons







-- Load some meshes to be processed
-- global meshFileNames = getFiles "E:\\Drive\\Dropbox (MIT)\\Eyewire\\FullTime\\TribecaFF\\Assets\\Cells\\Circuit\\hi-res\\*.obj"
-- global meshFileNames = getFiles "I:\\Collection\\*.obj"
global meshFileNames = getFiles "E:\\Drive\\Dropbox (MIT)\\Eyewire\\FullTime\\TribecaFF\\Assets\\Cells\\Collection\\taubin-smooth\\bipolar-ts-low\\*.obj"
global baseDirectory = "E:\\Drive\\Dropbox (MIT)\\Eyewire\\FullTime\\TribecaFF\\Assets\\Cells\\Collection\\taubin-smooth\\"
global outputDirectory = baseDirectory + "\\all_cells"


-- Make directory for iterative processing
fn makeDirectory = (
-- 	iterations = GetDirectories(baseDirectory + "/*")
-- 	iterations = iterations.count + 1
-- 	iterations = iterations as string

-- 	outputDirectory = outputDirectory + "-" + iterations
	makeDir outputDirectory
	print outputDirectory as string
)


/*

	Geometry Modifiers & Modeling

*/



fn nNormalizer obj = (
	/*
		The Normal modifier allows you to unify or flip the normals of 
		an object without applying an Edit Mesh modifier.
	*/

	print "Applying Normal Modifier.."

	local normalMod = normalModifier()	-- Declare modifier
	normalMod.unify = true		-- Set attributes
	normalMod.flip  = true	
	
	addModifier obj normalMod 	-- Apply modifier

	print "Complete."
)

fn nTurboSmooth obj itr = (
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

	local TurboSmoothModifier = TurboSmooth()	-- Delcare modifier
	TurboSmoothModifier.iterations = itr 		-- Set attributes
	
	addModifier obj TurboSmoothModifier 		-- Apply modifier


	print "Complete."
)

fn nProOptimizer obj prcnt = (
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

	local ProOptModifier = ProOptimizer()	-- Delcare modifier

	ProOptModifier.OptimizationMode = 1 	-- (0) Crunch Borders (1) Protect Borders (2) Exclude Borders 
	ProOptModifier.VertexPercent = prcnt 	-- Reduce mesh to 10% original vertex
	
	addModifier obj ProOptModifier 		-- Apply modifier

	print "Complete."
)

fn runProOptimizer obj = (
	print "Running ProOptimizer Modifier.."

	obj.modifiers[#ProOptimizer].Calculate = True -- Run optimization
-- 	sleep 3

	print "Complete."
)

fn nRelax obj val = (
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

	local relaxModifier = Relax() 		-- Delcare modifier

	relaxModifier.iterations = 1 		-- Set attributes
	relaxModifier.Relax_Value = val		-- Set attributes
	
	addModifier obj relaxModifier 		-- Apply modifier


	print "Complete."
)

fn bioize mesh = (
	select mesh -- Select working object

-- 	nProOptimizer mesh 25		-- Apply ProOptimizer (10% skeleton) (50% volumetric)
-- 	runProOptimizer mesh 		-- Run Optimization

-- 	nTurboSmooth mesh 1 -- Apply TurboSmooth (2 skeleton) (1 volumetric)

	ConvertTo mesh Editable_Poly -- Make sure we are dealing with Editable Poly
	nNormalizer mesh      		-- Unify Normals
	
	ConvertTo mesh Editable_Poly -- Make sure we are dealing with Editable Poly
)

fn optimizeMesh mesh percent = (
	select mesh -- Select working object

	for m in mesh.modifiers do
	(
		print m
		print "Removing previous Optimization"
		if classOf m==ProOptimizer do deleteModifier mesh m
	)

	print "Adding addtional Optimization"

	nProOptimizer mesh percent		-- Apply ProOptimizer (initial compression)
	runProOptimizer mesh 		-- Run Optimization
)

struct runProcess (
-- 		monitorProgress = #(),
	mesh,
	method,
	i,

	fn run =
	(				
		select mesh -- Select working object

		index = i as String
		mesh_count = meshFileNames.count as String
		mesh_id = mesh as String
	
		print ("Starting Mesh: " + mesh_id + "\n number:" + index + "|" + mesh_count)

		method(mesh) -- Run Method on mesh

		print ("Mesh Complete")
		print "\n"
	)
)

-- Avoid pesky dialog pop-ups
fn checkDialog = (
	local hwnd = dialogMonitorOps.getWindowHandle()
	if (uiAccessor.getWindowText hwnd == "Import Name Conflict") then (
		uiAccessor.PressButtonByName hwnd "OK"
	)
	true
)

-- Disable dialog pop-ups
fn impOptions = (
 	#noPrompt -- why not

 	dialogMonitorOps.enabled = true
	dialogMonitorOps.unRegisterNotification id:#test
	dialogMonitorOps.registerNotification checkDialog id:#test
	dialogMonitorOps.enabled = false

	-- Import Settings
	edit (objimp.getIniName())
	theINI =objimp.getIniName()
	setIniSetting theINI"Geometry""CenterPivots" "1"  -- Center Pivots

	#noprompt
)

fn exportMesh meshName = (
	-- Export meshFileNames
  	print ("Exporting " + meshName + "..")
  	local meshExport = outputDirectory + "\\" + meshName + ".obj"
  	exportFile meshExport #noPrompt selectedOnly:true using:OBJEXP
  	print "Success \n"
)

fn processMesh mesh = (

	local meshName = getFilenameFile mesh as string
 	print ("Importing " + meshName)

 	impOptions()

 	-- Import Mesh
    importFile mesh #noPrompt

	-- Set the name of the current import
	-- Assume the current import name <default>
-- 	local activeMesh = getNodeByName default -- Note this only works with og omni cells
-- 	local activeMesh = getNodeByName meshName -- Note this only works with og omni cells
	
	local activeMesh = getNodeByName "default"  -- Note this only works with og omni cells
	activeMesh.name = meshName

	bioStruct = runProcess activeMesh bioize i -- Decimate mesh to 10% original
	bioStruct.run() -- Run bioize on Meshes

	-- Export meshes at different mip levels
	for i = 1 to 1 do (  -- Changed to 1 to only downsample first mip level
		local decimationFactor

		if i == 1  then
			decimationFactor = 1 -- Default 5
		else if i == 2 then
			decimationFactor = 10
		else if i == 3 then
			decimationFactor = 15
		else if i == 4 then
			decimationFactor = 25
		else if i == 5 then
			decimationFactor = 50
		else if i == 6 then
			decimationFactor = 75

		optimizeMesh activeMesh decimationFactor -- Optimize mesh at different mip levels

		decimationFactor = decimationFactor as string

		local meshExpName = activeMesh.name + "_" + decimationFactor
		exportMesh meshExpName
	)

  	-- Delete activeMesh + End Selection
  	max delete
  	max select none

  	-- Run garbage collection
  	print "Running garbage collection.."
  	gc()
)

fn importMesh mesh = (

	local meshName = getFilenameFile mesh as string
 	print ("Importing " + meshName)

 	-- Import Mesh
    importFile mesh #noPrompt

    -- Set the name of the current import
	-- Assume the current import name <default>
-- 	local activeMesh = getNodeByName "default" -- Note this only works with og omni cells
-- 	print ("Meshname: " + activeMesh.name)
-- 	activeMesh.name = meshName

  	-- Run garbage collection
  	print "Running garbage collection.."
  	gc()
)

fn loopMesh = (
	print "Beginning Mesh Processing..\n"

-- 	makeDirectory()

	for i = 1 to meshFileNames.count do (
		local mesh = meshFileNames[i]

-- 		processMesh mesh
		importMesh mesh

		-- Run garbage collection
		print "Running garbage collection.."
		gc()

	)

	print "Mesh Processing Complete."

)

-- Call loopMesh()
loopMesh()