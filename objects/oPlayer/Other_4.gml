// Making camera track to the player's coordinates
xForCamera = x;
yForCamera = y;

// Reset Player State
//playerState = STATE_WALKING;

// Setting up collision tilemaps
tilemap = layer_tilemap_get_id("Collision");
jumppoint = layer_tilemap_get_id("JumpPoints");

// Making a checkpoint at the start of the room
global.checkpointX = x;
global.checkpointY = y;


// Tracking Camera to player
with oCamera {
	view_enabled = true;
	view_visible[0] = true;

	viewWidth = global.windowW;
	viewHeight = global.windowH;

	camera_set_view_size(view_camera[0], viewWidth, viewHeight);

	var xTo = clamp(oPlayer.xForCamera - global.windowW/2, 0, room_width - viewWidth);
	var yTo = clamp(room_width - global.windowH - 10, 0, room_height - viewHeight - 12);

	x = xTo;
	y = yTo;

	camera_set_view_pos(view_camera[0], x, y);
}
