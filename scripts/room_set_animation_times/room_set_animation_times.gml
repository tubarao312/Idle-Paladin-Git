function room_set_animation_times(current, halfway, delay, ending) {
	global.roomTransitioning.roomTransitionCurrentFrame	= round(current);
	global.roomTransitioning.roomTransitionHalfwayFrame	= round(halfway);
	global.roomTransitioning.roomTransitionMiddleDelay  = round(delay);
	global.roomTransitioning.roomTransitionMaximumFrame	= round(ending);
}