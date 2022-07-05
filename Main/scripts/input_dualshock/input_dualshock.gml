function input_gamepad(inp){
	
	var result
	
	result[PRESSED] = gamepad_button_check_pressed(0, inp)
	result[HELD] = gamepad_button_check(0, inp)
	result[RELEASED] = gamepad_button_check_released(0, inp)
	
	return result
}
