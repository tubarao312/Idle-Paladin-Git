cursorOverSymbol = cursor_in_box(x+22,y+5,x+65,y+27)

if cursorOverSymbol and !oUIMenuHub.showUp and global.UIElementShowing != UI_SKILLTREE {
	image_index = 1
	cursor_skin(1)
	
	if mbLeft[PRESSED] {
		oUIMenuHub.showUp = true
		global.UIElementShowing = UI_MENUHUB
		update_player_stats();
	}
} else {
	image_index = 0
}

draw_self()