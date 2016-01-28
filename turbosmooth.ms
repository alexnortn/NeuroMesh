/*This is my first script, I was sick of manually clicking the same stuff every time I add a turbo smooth modifier. 
*/

MacroScript Brads_TurboSmooth category:"Brads Tools" buttonText:"Brads Turbo" tooltip:"Add 2 turbo, Add 3 Render It, Isoline Display, Explicit Normals"
(
modPanel.addModToSelection (TurboSmooth ()) ui:on
$.modifiers[#TurboSmooth].iterations = 2
$.modifiers[#TurboSmooth].useRenderIterations = on
$.modifiers[#TurboSmooth].renderIterations = 3
$.modifiers[#TurboSmooth].isolineDisplay = on
$.modifiers[#TurboSmooth].explicitNormals = on
)
