#region //Screen Resolution:
if keyboard_check_pressed(vk_f11) {
	fullscreenEnabled = !fullscreenEnabled
	window_set_fullscreen(fullscreenEnabled)
	
	reset_display()
}
#endregion

viewWidth = global.windowW;
viewHeight = global.windowH;

camera_set_view_size(view_camera[0],viewWidth,viewHeight);

if instance_exists(oPlayer) {

	var xTo = clamp(oPlayer.xForCamera - global.windowW/2, 0, room_width - viewWidth);
	var yTo = clamp(room_width - global.windowH - 10, 0, room_height - viewHeight - 12);

	if cameraMode = CAMERA_MODE.WALKING {
	x += min(((xTo - x) / 32), xMaxSpd * sign((xTo - x)))
	y += min(((yTo - y) / 32), yMaxSpd * sign((yTo - y)))

	if ((xTo - x) / 32) > abs(xMaxSpd) then xMaxSpd += 0.05
	else xMaxSpd = approach(xMaxSpd,2.5,-0.1)

	if ((yTo - y) / 16) > abs(yMaxSpd) then yMaxSpd += 0.05
	else yMaxSpd = approach(yMaxSpd,2.5,-0.1)
	}
	else if cameraMode = CAMERA_MODE.TOWN {
		x += abs((xTo - x) / 16) * sign((xTo - x));
		y += min(((yTo - y) / 32), 10*sign((yTo - y)));
	}
	
	camera_set_view_pos(view_camera[0], x, y);
}

x += round(random_range(-shake_remain, shake_remain));
y += round(random_range(-shake_remain, shake_remain));
shake_remain = round(max(0, shake_remain - ((1 / shake_length) * shake_magnitude)));

#region Parallax and Passive Particles ---------------------------------------------

switch room {
	case rGreenpath: {
		layer_x("Background1",floor(x*0.25));
		layer_x("Background2",floor(x*0.5 + xSkyOffset2));
		layer_x("Background3",floor(x*0.75 + xSkyOffset3));

		xSkyOffset2 += 0.25;
		xSkyOffset3 += 0.125;
	break; }

	case rTownHub: {
		layer_x("Background1",floor(x*0.25));
		layer_x("Background2",floor(x*0.5 + xSkyOffset2));
		layer_x("Background3",floor(x*0.75 + xSkyOffset3));

		xSkyOffset2 += 0.25;
		xSkyOffset3 += 0.125;
		
	break; }
	
	case rShopInterior: {
		layer_x("Background1",floor(x*0.25));
		layer_x("Background2",floor(x*0.5 + xSkyOffset2));
		layer_x("Background3",floor(x*0.75 + xSkyOffset3));

		xSkyOffset2 += 0.25;
		xSkyOffset3 += 0.125;
		
	break; }

	case rDesert: {
		layer_x("Background1",floor(x*0.75  + xSkyOffset3));
		layer_x("Background2",floor(x*0.625 + xSkyOffset2));
		layer_x("Background3",floor(x*0.50));
		layer_x("Background4",floor(x*0.30));
		layer_x("Background5",floor(x*0.20));

		xSkyOffset2 += 0.25;
		xSkyOffset3 += 0.125;
	break; }
		
	case rJungle: {
		layer_x("Background1",floor(x*0.25));
		layer_x("Background2",floor(x*0.5));
		layer_x("Background3",floor(x*0.75));
	break; }
	
	case rTundra: {
		var chanc = max(0.10, min(0.60, (dsin(current_time/100) + 1) / 2));
		if chance(chanc) then instance_create_layer(x + random_range(-200, 1500), 270, "Camera", oFallingSnowParticle);
		
		layer_x("Background3",floor(x*0.25));
		layer_x("Background2",floor(x*0.5));
		layer_x("Background1",floor(x*0.75));
	break; }
	
	case rMagmaCave: {
		layer_x("Background1",floor(x*0.25));
		layer_x("Background2",floor(x*0.50));
		layer_x("Background3",floor(x*0.75));
	break; }

}

#endregion

#region Object Culling ---------------------------------------

with oEnemyParent {
	if abs(x-oPlayer.x) > global.windowW+100 instance_deactivate_object(self);
}

with oItemDropParent {
	if abs(x-oPlayer.x) > global.windowW+100 instance_deactivate_object(self);
}


instance_activate_region(x-50,y-50,global.windowW+100,global.windowH+100,true);

#endregion