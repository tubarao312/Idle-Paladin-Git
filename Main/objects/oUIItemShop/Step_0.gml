showUp = (global.UIElementShowing = UI_ITEMSHOP)

if showUp {
	yRel = ceil(lerp(yRel,0,0.1))
} else {
	yRel = ceil(lerp(yRel,-300,0.05))
}

y = ogY + yRel