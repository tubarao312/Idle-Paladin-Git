surSpace = surface_create(global.windowW, global.windowH);

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
						// Here, draw space surface
						
						
						//draw_clear_alpha(rt.color, animationPercentage);
					
					break; }
				
					case ROOM_TRANSITION_TYPES.circle: {
						draw_clear_alpha(rt.color, 1);
						gpu_set_blendmode(bm_subtract);

						draw_circle(oPlayer.x - oCamera.x + 10, oPlayer.y - oCamera.y + 10, round((1 - animationPercentage) * global.windowW / 5)*5, false);
						
						gpu_set_blendmode(bm_normal);
					break; }
				
					case ROOM_TRANSITION_TYPES.slideRight: {
						
						if !surface_exists(surSpace) then surSpace = surface_create(global.windowW + 20, global.windowH + 20);
						surface_set_target(surSpace); {
							draw_clear_alpha(c_white, 0);
							
							// Draw Space
							draw_space_background(2 - animationPercentage);
							
							// Draw Player Sprite
							gpu_set_fog(true, $f6e14b, 0, 1);
							draw_sprite_ext(oPlayer.sprite_index, oPlayer.image_index, oPlayer.x - oCamera.x, oPlayer.y - oCamera.y, oPlayer.image_xscale, oPlayer.image_yscale, oPlayer.image_angle, c_white, 1);
							gpu_set_fog(false, c_white, 0, 1);
							
							// Draw Barriers
							var baseX = (20 + global.windowW) * animationPercentage;
							
							for (var i = 0; i < global.windowH / 2 + 10; i++) {
								var Y = i * 2;
								var X = baseX + 6 * sqrt(sqrt(0.5 + animationPercentage)) * sin((0.5 + animationPercentage) * sin((0.5 + animationPercentage) + Y/20)) * Y/70;
								
								gpu_set_blendmode(bm_subtract);
								draw_sprite_ext(sSpaceTransSideClearer, 0, X, Y, 1, 1, 0, c_white, 1);
							
								gpu_set_blendmode(bm_normal);
								draw_sprite_ext(sSpaceTransBarrier, round(X%2), X, Y, -1, 1, 0, c_white, 1);
							}
							
						surface_reset_target(); }
						
						draw_surface(surSpace, 0, 0);
		
					break; }
				
					case ROOM_TRANSITION_TYPES.slideLeft: {
						// Here, draw space surface
					
						if !surface_exists(surSpace) then surSpace = surface_create(global.windowW + 20, global.windowH + 20);
						surface_set_target(surSpace); {
							draw_clear_alpha(c_white, 0);
							
							// Draw Space
							draw_space_background(animationPercentage);
							
							// Draw Barriers
							var baseX = (20 + global.windowW) * (1 - animationPercentage);
							
							for (var i = 0; i < global.windowH / 2 + 10; i++) {
								var Y = i * 2;
								var X = baseX + 6 * sqrt(sqrt(animationPercentage)) * sin(animationPercentage * sin(animationPercentage + Y/20)) * Y/70;
								
								gpu_set_blendmode(bm_subtract);
								draw_sprite_ext(sSpaceTransSideClearer, 0, X, Y, -1, 1, 0, c_white, 1);
							
								gpu_set_blendmode(bm_normal);
								draw_sprite_ext(sSpaceTransBarrier, (X%2), X, Y, 1, 1, 0, c_white, 1);
							}
							
						surface_reset_target(); }
						
						draw_surface(surSpace, 0, 0);
					break; }
				}
			
			
				gpu_set_blendmode(bm_normal);
				surface_reset_target(); }
			
			draw_surface(rt.canvas, -10, -10);
	
	}
}


function room_advance_transition() { // When the room actually transitions
	var rt = global.roomTransitioning;
	
	rt.roomTransitionCurrentFrame++;
	rt.roomTransitionCurrentFrame = min(rt.roomTransitionCurrentFrame, rt.roomTransitionMaximumFrame);
	
	if rt.roomTransitionCurrentFrame == rt.roomTransitionHalfwayFrame {
		room_goto(rt.roomToTransitionTo);
		
		if instance_exists(oPlayer) { // TPing the player inside the next room
			oPlayer.x = rt.nextRoomStartingX;
			oPlayer.y = rt.nextRoomStartingY;
			oPlayer.visuals.skipNextGroundSmokeEffect = true;
			
			if room = rTownHub then currentPlayerStats.reset();
			
			with oPlayer change_player_superstate(global.roomTransitioning.roomTransitionNewSuperstate);
		}
	}
}

function draw_space_background(percentage) { // Percentage goes from 0 to 1
	draw_sprite(sSpaceTransBG, 0, 		- percentage * 50 - 200, -100 - percentage * 10);
	draw_sprite(sSpaceTransClouds, 0, 	- percentage * 75 - 200, -100 - percentage * 10);
	draw_sprite(sSpaceTransStars, 0, 	- percentage * 100, -percentage * 10);
	draw_sprite(sSpaceTransPlanets, 0, 	- percentage * 125, -percentage * 10);
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
	