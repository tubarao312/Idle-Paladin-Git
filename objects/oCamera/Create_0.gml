
//Window Size---------------------------------
canStartCulling = false;
fullscreenEnabled = false;

reset_display()

//Setting up HUD-----------
//instance_create_layer(5,5,"HUD",ohudHPBar)
//instance_create_layer(global.windowW-40,global.windowH-36,"HUD",ohudInv)
//instance_create_layer(global.windowW-15,15,"HUD",ohudXPDisplay)
//--------------------------

x = oPlayer.xForCamera;
y = room_height-global.windowH/2-20

camera = camera_create();

var vm = matrix_build_lookat(x, y, -10, x, y, 0, 0, 1, 0);
var pm = matrix_build_projection_ortho(global.windowW, global.windowH, 1, 10000);

camera_set_view_mat(camera, vm) camera_set_proj_mat(camera, pm) view_camera[0] = camera

xTo = x;
yTo = y;

shake_length = 0;
shake_magnitude = 0;
shake_remain = 0;

xMaxSpd = 2.5
yMaxSpd = 2.5

//Test---------------

targetX = 0
targetY = 0
targetX2 = 0
targetY2 = 0

currentX = 0
currentY = 0
currentX2 = 0
currentY2 = 0

// Parallax Variables
xSkyOffset = 0;

alarm[0] = 1
alarm[1] = 1

