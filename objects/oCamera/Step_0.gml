#region //Screen Resolution:
if keyboard_check_pressed(vk_f11) {
	fullscreenEnabled = !fullscreenEnabled
	window_set_fullscreen(fullscreenEnabled)
	
	reset_display()
}

#endregion

#region //Camera Follow:
x += min(((xTo - x) / 32),xMaxSpd*sign((xTo - x)))
y += min(((yTo - y) / 32),yMaxSpd*sign((yTo - y)))

if ((xTo - x) / 32) > abs(xMaxSpd) then xMaxSpd += 0.05
else xMaxSpd = approach(xMaxSpd,2.5,-0.1)

if ((yTo - y) / 16) > abs(yMaxSpd) then yMaxSpd += 0.05
else yMaxSpd = approach(yMaxSpd,2.5,-0.1)

xTo = oPlayer.xForCamera+global.windowW/2;
yTo = room_height-global.windowH/2-50;

var vm = matrix_build_lookat(floor(x), floor(y), -10, floor(x), floor(y), 0, 0, 1, 0);
camera_set_view_mat(camera, vm)
#endregion

#region //Screenshake:
x += round(random_range(-shake_remain, shake_remain))
y += round(random_range(-shake_remain, shake_remain))
shake_remain = round(max(0, shake_remain - ((1 / shake_length) * shake_magnitude)))
#endregion

#region //Parallax

layer_x("Background1",floor(oCamera.x*0.25))
layer_x("Background2",floor(oCamera.x*0.5))
layer_x("Background3",floor(oCamera.x*0.75 + xSkyOffset))

xSkyOffset += 1;

#endregion