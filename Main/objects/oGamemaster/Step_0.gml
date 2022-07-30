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
global.currentFrameEffects.step();
currentPlayerStats.update();

#region Developer Mode

// Enable and Disable HUD [TESTING]
if keyboard_check_pressed(vk_f12) {
	global.enableHUD = !global.enableHUD;
}

// Town Room X and Y: (0, 450)
// Normal Room X and Y: (1110, 430)

// Change Player Superstate
if keyboard_check_pressed(vk_f1) {
	with oPlayer change_player_superstate(PLAYER_SUPERSTATES.inTown);
} else if keyboard_check_pressed(vk_f2) {
	with oPlayer change_player_superstate(PLAYER_SUPERSTATES.inCombat);
}

// Moving Rooms
if keyboard_check_pressed(vk_f10) {
	var possibleRooms = [rTownHub, rDesert, rGreenpath, rJungle, rMagmaCave, rTundra, rGreenscreen, rGreenscreen];
	
	var i; // Find Current Room
	for (i = 0; i < array_length(possibleRooms); i++) {
		if room == possibleRooms[i] then break;
	}
	
	if i == array_length(possibleRooms)-1 then i = -1; // Loop over
	i++; // Go to next room
	
	// Coordinates to land at
	var coordX = 0;
	var coordY = 450;
	
	if possibleRooms[i] == rTownHub { // If it's the town, go somewhere else
		coordX = 1110;
		coordY = 430;
	}
		
	dev_move_room(possibleRooms[i], coordX, coordY);
	
}

function dev_move_room(nextRoom, X, Y) {
	room_set_next_room(nextRoom, X, Y);
	room_set_transition_type_begin(2);
	room_set_transition_type_end(3);
	room_set_animation_times(0, 60*1.5, 60*0, 60*3);
}

#endregion

// Cursor Layers System
// Looks for the first layer that is found and sets it as the active layer
for (i = CURSOR_LAYERS.size-1; i >= 0; i--) {
	if global.cursorActiveLayers[i] {
		global.cursorPriorityLayer = i;
		break;
	}
}


