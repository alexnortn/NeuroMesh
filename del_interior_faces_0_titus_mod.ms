-- //it's a small modification of ""deleteUselessFaces" script by Titus//
try(destroyDialog ::deleteUselessFaces_Rollout)catch()
rollout deleteUselessFaces_Rollout "deleteUselessFaces" 


(
	groupBox GRP "Steps:" pos:[5,5] width:190 height:90	
	button SelUseless "1: Select useless faces" pos:[25,25] width:150 height:25
	button DelUseless "2: Delete temporary mesh" pos:[25,55] width:150 height:25
	

	on SelUseless pressed do
    
undo enable on
(	
if selection.count != 1 and classof $ != Editable_Poly then 
	( 
	messageBox "Select one EditablePoly object" title:"-WARNING-" beep:false )	
	else (
xViewChecker.on = false;
macros.run "Modifier Stack" "Convert_to_Poly"
a=$

maxOps.cloneNodes $ cloneType:#copy newNodes:&nnl
select nnl
b=$

subobjectLevel = 3
max select all
$.EditablePoly.buttonOp #Chamfer
max select all
$.EditablePoly.collapse #Edge



c = Box lengthsegs:1 widthsegs:1 heightsegs:1
select c
modPanel.addModToSelection (DeleteMesh ()) ui:on
macros.run "Modifier Stack" "Convert_to_Poly"



ProBoolean.CreateBooleanObject c b 0 2 0

select c



modPanel.addModToSelection (smooth ()) ui:on
$.modifiers[#Smooth].smoothingBits = -2147483648
macros.run "Modifier Stack" "Convert_to_Poly"


select a


$.EditablePoly.attach c $


subobjectLevel = 4
	
	
xViewChecker.autoUpdate = true
macros.run "xView" "xView_Overlapping_Faces_Checker"


macros.run "xView" "xView_Select_Results"

max select invert

macros.run "xView" "xView_Overlapping_Faces_Checker"
) 
)
	

on DelUseless pressed do
    
undo enable on
(
	if selection.count != 1 and classof $ != Editable_Poly then 
	( 
	messageBox "Select one EditablePoly object" title:"-WARNING-" beep:false )	
	else (
$.EditablePoly.delete #Face;	
$.EditablePoly.selectBySmoothGroup -2147483648
$.EditablePoly.delete #Face;
--max delete

subobjectLevel = 0
	)
)

)


createDialog deleteUselessFaces_Rollout 200 100





