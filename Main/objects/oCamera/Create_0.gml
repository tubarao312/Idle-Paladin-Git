viewWidth = global.windowW;
viewHeight = global.windowH;

windowScale = 4;

window_set_size(global.windowW*windowScale,global.windowH*windowScale);
alarm[0] = 1;

surface_resize(application_surface,global.windowW,global.windowH);

xMaxSpd = 2.5;
yMaxSpd = 2.5;

fullscreenEnabled = false;

shake_magnitude = 0
shake_remain = 0
shake_length = 0

enum CAMERA_MODE {
	TOWN,
	WALKING,
	
}

cameraMode = CAMERA_MODE.TOWN;

xSkyOffset2 = 0;
xSkyOffset3 = 0;