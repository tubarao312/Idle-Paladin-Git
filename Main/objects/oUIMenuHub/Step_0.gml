if showUp {
	xRel = ceil(lerp(xRel,0,0.15))
	
	if !cursor_in_box(ogX-30,y,ogX+123,y+140) then global.UIElementShowing = UI_NOTHING
	
} else {
	xRel = ceil(lerp(xRel,150,0.05))
}

showUp = (global.UIElementShowing = UI_MENUHUB)