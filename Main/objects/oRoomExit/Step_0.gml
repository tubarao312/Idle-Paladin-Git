if !hasStartedTransition and (!interactionRequired or oPlayer.inputs.interact[PRESSED]) and point_distance(oPlayer.x, oPlayer.y, x, y) < proximityRequired {
	
	hasStartedTransition = true;
	
	room_set_next_room(nextRoom, nextRoomBeginningX, nextRoomBeginningY);
	room_set_transition_color(transitionColor);
	room_set_transition_type_begin(transitionBeginType);
	room_set_transition_type_end(transitionEndType);
	room_set_next_superstate(nextPlayerSuperstate);
	room_set_animation_times(0, 60*transitionHalfwayTime, 60*transitionHalfwayDelay, 60*transitionMaximumTime);
	//room_set_next_reset_stats(resetCurrentPlayerStats);
}

