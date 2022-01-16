showUp = (global.UIElementShowing = UI_ABILITIES)

if showUp {
	xRel = floor(lerp(xRel,0,0.15))
	
} else {
	xRel = floor(lerp(xRel,125,0.05))
}