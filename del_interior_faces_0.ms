rollout selectorRollout "deleteUselessFaces" 


(
	
	button DelUseless "Delete useless faces!!!"

	on DelUseless pressed do
    
	undo enable on (	
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

		max delete

		$.EditablePoly.selectBySmoothGroup -2147483648

		max delete

		subobjectLevel = 0

		macros.run "xView" "xView_Overlapping_Faces_Checker"
	)

)


createDialog selectorRollout 





