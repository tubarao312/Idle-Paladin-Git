
global.roomTransitioning = {
	// The room you're moving to
	roomToTransitionTo: rTownHub,
	
	// The current frame of the animation and how many frames it has
	roomTransitionMaximumFrame: 60,
	roomTransitionHalfwayFrame: 30,
	roomTransitionMiddleDelay:  10,
	roomTransitionCurrentFrame: 0,
	
	// How the animation plays out
	roomBeginTransitionType:  ROOM_TRANSITION_TYPES.fade,
	roomFinishTransitionType: ROOM_TRANSITION_TYPES.fade,
	
	// Color for the animation
	color: $32191a,
	
	// Surface for the animation
	canvas: surface_create(global.windowW + 20, global.windowH + 20),
	
	// Next player superstate
	roomTransitionNewSuperstate: PLAYER_SUPERSTATES.inTown,
}

function room_draw_transition() {
	var rt = global.roomTransitioning;
	
	if rt.roomTransitionCurrentFrame < rt.roomTransitionMaximumFrame {
	
		var transitionType, transitionState; { // Choosing which transition animation should be used
			// Choosing the room transitioning types and states
			if rt.roomTransitionCurrentFrame > rt.roomTransitionHalfwayFrame + rt.roomTransitionMiddleDelay {
				transitionType = rt.roomFinishTransitionType;
				transitionState = ROOM_TRANSITION_STATE.finish;
			}
			else if rt.roomTransitionCurrentFrame > rt.roomTransitionHalfwayFrame {
				transitionState = ROOM_TRANSITION_STATE.middle;
				transitionType = rt.roomBeginTransitionType;
			}
			else {
				transitionType = rt.roomBeginTransitionType;
				transitionState = ROOM_TRANSITION_STATE.start;
			}
		}
			// If the surface doesn't exist, create it again
			if !surface_exists(rt.canvas) then rt.canvas = surface_create(global.windowW + 20, global.windowH + 20);
		
			surface_set_target(rt.canvas); { // Drawing to canvas
				draw_clear_alpha(c_white, 0);
			
				var animationPercentage;
				switch transitionState { // Calculating the animation percentage
					case ROOM_TRANSITION_STATE.start: {
						animationPercentage = rt.roomTransitionCurrentFrame / rt.roomTransitionHalfwayFrame;
					break; }
				
					case ROOM_TRANSITION_STATE.middle: {
						animationPercentage = 1;
					break; }
				
					case ROOM_TRANSITION_STATE.finish: {
						var currentFrame = rt.roomTransitionCurrentFrame - rt.roomTransitionHalfwayFrame - rt.roomTransitionMiddleDelay;
						var total = rt.roomTransitionMaximumFrame - rt.roomTransitionHalfwayFrame - rt.roomTransitionMiddleDelay;
					
						animationPercentage = 1 - (currentFrame / total);
					break; }
				
				}
			
				switch transitionType { // Each transition is drawn differently
					case ROOM_TRANSITION_TYPES.fade: {
						draw_clear_alpha(rt.color, animationPercentage);
					
					break; }
				
					case ROOM_TRANSITION_TYPES.circle: {
						draw_clear_alpha(rt.color, 1);
						gpu_set_blendmode(bm_subtract);

						draw_circle(oPlayer.x - oCameraTest.x + 10, oPlayer.y - oCameraTest.y + 10, round((1 - animationPercentage) * global.windowW / 5)*5, false);
						
						gpu_set_blendmode(bm_normal);
					break; }
				
					case ROOM_TRANSITION_TYPES.slideRight: {
						draw_rectangle_color(0, 0, (20 + global.windowW) * animationPercentage, global.windowH + 20, rt.color, rt.color, rt.color, rt.color, false);
		
					break; }
				
					case ROOM_TRANSITION_TYPES.slideLeft: {
						draw_rectangle_color(global.windowW + 20, 0, (global.windowW + 20) * (1 - animationPercentage), global.windowH + 20, rt.color, rt.color, rt.color, rt.color, false);
					break; }
				}
			
			
				gpu_set_blendmode(bm_normal);
				surface_reset_target(); }
			
			draw_surface(rt.canvas, -10, -10);
	
	}
}


function room_advance_transition() {
	var rt = global.roomTransitioning;
	
	rt.roomTransitionCurrentFrame++;
	rt.roomTransitionCurrentFrame = min(rt.roomTransitionCurrentFrame, rt.roomTransitionMaximumFrame);
	
	if rt.roomTransitionCurrentFrame == rt.roomTransitionHalfwayFrame {
		room_goto(rt.roomToTransitionTo);
		
		if instance_exists(oPlayer) { // TPing the player inside the next room
			oPlayer.x = rt.nextRoomStartingX;
			oPlayer.y = rt.nextRoomStartingY;
			oPlayer.visuals.skipNextGroundSmokeEffect = true;
			
			with oPlayer change_player_superstate(global.roomTransitioning.roomTransitionNewSuperstate);
		}
	}
}

enum ROOM_TRANSITION_TYPES {
	fade,
	circle,
	slideLeft,
	slideRight,
	none,
}

enum ROOM_TRANSITION_STATE {
	start,
	middle,
	finish,
}
	