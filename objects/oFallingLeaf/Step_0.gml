/// @description Destroy

if abs(x - oCamera.x) > (global.windowW * 2.5) or (y > room_height) {
	instance_destroy();
}