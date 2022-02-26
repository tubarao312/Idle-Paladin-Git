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