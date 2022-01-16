function input(inp){
	
	var result
	
	#macro PRESSED	0
	#macro HELD		1
	#macro RELEASED 2
	
	if inp = mb_left or inp = mb_right {
		result[PRESSED] = mouse_check_button_pressed(inp)
		result[HELD] = mouse_check_button(inp)
		result[RELEASED] = mouse_check_button_released(inp)
	} else {
		result[PRESSED] = keyboard_check_pressed(inp)
		result[HELD] = keyboard_check(inp)
		result[RELEASED] = keyboard_check_released(inp)
	}
	
	return result
}