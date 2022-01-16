/// @description Destroy

if abs(x - oCameraTest.x) > (global.windowW * 2.5) or (y > room_height) {
	instance_destroy();
}