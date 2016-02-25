-- Load some meshes to be processed
global meshes = getFiles "\\\\Notus\\Users\\Public\\3dsMax\\Eyewire-Cells\\MuseumCells\\test\\*.obj"

global baseDirectory = "\\\\Notus\\Users\\Public\\3dsMax\\Eyewire-Cells\\MuseumCells\\test"
global outputDirectory = baseDirectory + "\\output"


-- Make directory for iterative processing
fn makeDirectory = (
	iterations = GetDirectories(baseDirectory+"/*")
	iterations = iterations.count + 1
	iterations = iterations as string

	outputDirectory = outputDirectory + "-" + iterations
	makeDir outputDirectory
	print outputDirectory as string
)

makeDirectory()

-- Avoid pesky dialog pop-ups
 fn checkDialog = (
 	local hwnd = dialogMonitorOps.getWindowHandle()
 	if (uiAccessor.getWindowText hwnd == "Import Name Conflict") then (
 		uiAccessor.PressButtonByName hwnd "OK"
 	)
 	true
 )

fn processMesh = (
	for mesh in meshes do 
	(
		#noPrompt -- why not

		dialogMonitorOps.enabled = true
		dialogMonitorOps.unRegisterNotification id:#test
		dialogMonitorOps.registerNotification checkDialog id:#test

	    importFile mesh #noPrompt -- your code here
	 	dialogMonitorOps.enabled = false

	 	local meshName = getFilenameFile mesh as string

		-- Set the name of the current import
		local activeMesh = getNodeByName "default"
			  activeMesh.name = meshName

	  	-- Process Mesh
	  	select activeMesh 

	  	-- Export Meshes
	  	print ("Exporting " + activeMesh.name + "..")
	  	exportFile outputDirectory + "\\" + activeMesh.name + ".obj" #noPrompt selectedOnly:true using:OBJEXP
	  	print "Success"

	  	-- Delete activeMesh + End Selection
	  	max delete
	  	max select none
	)
)

processMesh()

