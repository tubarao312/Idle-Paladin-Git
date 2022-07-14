#region Movement and Player State Machine
/* Explanation: -------------------------------------------------------------------------
	Instead of doing the horizontal collision first and the vertical collision second,
these are checked at the same time to allow for more precise physicsement. */

// Processes physics, visuals and sound
update_step();

superstate_machine_update(superstateMachine);


#endregion

#region Reading Hits Taken

read_hits_taken_list();

#endregion

#region Picking Up Coins
ds_list_clear(itemsPickedUpList)
instance_place_list(x,y,oItemDropParent,itemsPickedUpList,false);

if ds_list_size(itemsPickedUpList) > 0 {
	var i;
	for (i = ds_list_size(itemsPickedUpList) - 1; i >= 0; i --) {
		itemsPickedUpList[| i].startDestroying = true;
	}
}

#endregion

#region Camera Regions

var camZone = instance_place(x,y,oCameraZone);

if instance_exists(camZone) {
	if camZone.followX != 0 then xForCamera = camZone.followX;
	else xForCamera = x + xForCameraOffset;
	
	if camZone.followY != 0 then yForCamera = camZone.followY;
	else yForCamera = y + yForCameraOffset;
	
} else {
	xForCamera = x + xForCameraOffset;
}


#endregion

#region Falling out of the map
if y > 475 then {
	x = global.checkpointX;
	y = global.checkpointY;

	physics.xSpd = 0;
	add_player_hp(-playerStats.maxHP/15)
	whiteAlpha = 1.1;
}

#endregion