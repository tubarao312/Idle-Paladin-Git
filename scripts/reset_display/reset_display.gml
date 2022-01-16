// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function reset_display(){
	var idealHeight = 200
	var aspectRatio = window_get_width()/window_get_height()
	var idealWidth = round(idealHeight*aspectRatio)

	if idealWidth%1 then idealWidth++ //No monitor has an uneven pixel count

	global.windowW = max(idealWidth,1)
	global.windowH = max(idealHeight,1)
	
	surface_resize(application_surface,global.windowW,global.windowH)
	display_set_gui_size(global.windowW,global.windowH)

	/* FOR THE UI/HUD ELEMENTS:
	ANCHOR Variable: UI Element follows this anchor when the display gets scaled.
	This variable ranges from 1 to 9:
	 1 TOP_LEFT    | 2 TOP_CENTER    | 3 TOP_RIGHT
	---------------+-----------------+----------------
	 4 MIDDLE_LEFT | 5 MIDDLE_CENTER | 6 MIDDLE_RIGHT
	---------------+-----------------+----------------
	 7 BOTTOM_LEFT | 8 BOTTOM_CENTER | 9 BOTTOM_RIGHT
	*/
	
	global.xAnchorArray = [0,0,global.windowW/2,global.windowW,0,global.windowW/2,global.windowW,0,global.windowW/2,global.windowW]
	global.yAnchorArray = [0,0,0,0,global.windowH/2,global.windowH/2,global.windowH/2,global.windowH,global.windowH,global.windowH]
	
	//Having all the UI elements move to adapt:
	if global.createdUI then with oUIParent {
		x = global.xAnchorArray[anchor] + xCreate
		y = global.yAnchorArray[anchor] + yCreate
	}
}