global.cursorX = round(window_mouse_get_x()/(window_get_width()/global.windowW));
global.cursorY = round(window_mouse_get_y()/(window_get_height()/global.windowH));

if global.windowW = 1 or global.windowH = 1 then reset_display();

if keyboard_check(ord(vk_alt)) and keyboard_check(ord(vk_f4)) then game_end();

// Delayed Functions - Execute and delete once they reach 0
var i;
for (i = ds_list_size(global.delayedFunctions) - 1; i >= 0; i--) {
	var struct = global.delayedFunctions[|i];
	
	if struct.timer > 0 then struct.timer--;
	else {
		if instance_exists(struct.owner) then with struct.owner struct.execute_function(struct.functionVariables);
		ds_list_delete(global.delayedFunctions, i);
	}
}

// Screenfreeze
while (global.screenfreezeTime > current_time) {
	global.screenfreezeTime = lerp(global.screenfreezeTime, current_time, 0.05);
}

// Updating Current Player Stats
playerStats.recalculate();
currentPlayerStats.update();

print(playerStats);

// Enable and Disable HUD [TESTING]
if keyboard_check_pressed(vk_f12) {
	global.enableHUD = !global.enableHUD;
}

// Cursor Layers System
// Looks for the first layer that is found and sets it as the active layer
for (i = CURSOR_LAYERS.size-1; i >= 0; i--) {
	if global.cursorActiveLayers[i] {
		global.cursorPriorityLayer = i;
		break;
	}
}
