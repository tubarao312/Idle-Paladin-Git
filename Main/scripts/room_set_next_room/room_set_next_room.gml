function room_set_next_room(nextRoom, X, Y) {
	global.roomTransitioning.roomToTransitionTo = nextRoom;
	
	global.roomTransitioning.nextRoomStartingX = X;
	global.roomTransitioning.nextRoomStartingY = Y;
}