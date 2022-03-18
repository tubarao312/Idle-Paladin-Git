
/* About Components:
	Each component controls a part of the entity's behaviours.
	These do not work independent of each other, but there is a hard rule:
	One component can access other components' variables but it should never
	change them.
	
	There is an EXCEPTION: The state machine can access all components as well as change them.
*/

#region State Machine

superstateMachine = superstate_machine_create();

enum PLAYER_SUPERSTATES {
	inTown,
	inCombat,
	
	size,
}

enum STATES {
	start,
	step,
	finish,
}

#region Walking In Town SUPERSTATE ----------------------------------------------------------------#
playerSuperstate[PLAYER_SUPERSTATES.inTown] = superstate_create(); 

// State machine for running, jumping, etc...
var movementStateMachine = state_machine_create("movement");
superstate_add_state_machine(playerSuperstate[PLAYER_SUPERSTATES.inTown], movementStateMachine);

#region Walking

var state, stateFunc;

stateFunc[STATES.start] = function() {} // Start Walking (EMPTY)

stateFunc[STATES.step] = function() { // Step Walking
	
		#region Movement Defintions ---------------------------------------------------------------------------------------------
		if !inputs.dir then physics.hsp = lerp(physics.hsp, 0, 0.3);
		
		if inputs.dir != 0 then physics.dir = inputs.dir;
		
		physics.hacc = inputs.dir; // Walking left and right
		physics.vacc = physics.grav;
		
		physics.maxvsp = 5;
		physics.minvsp = -20;
		
		if physics.vsp < 0 { // Having higher speeds while jumping
			physics.maxhsp = (1.85 + sqrt(abs(physics.vsp))/2);
			physics.minhsp = -physics.maxhsp;
		} else {	
			physics.maxhsp = 1.85;
			physics.minhsp = -physics.maxhsp;
		}
		
		// Hitting the ceiling
		if physics.verticalCollision and physics.vsp < 0 then physics.vsp = 0;
		
		if physics.onGround and physics.vsp > 0 then physics.vsp = 0 // Sticking to the ground and not gaining speed
		
		#endregion ----------------------------------------------------------------------------------------------------------------
		
		#region Jumping ---------------------------------------------------------------------------------------------------------
		if inputs.jump[HELD]then alarm[3] = 3;
		var jump = physics.onGround and (alarm[3] > 0 or tilemap_get_at_pixel(jumppoint, bbox_right, bbox_bottom - 5));
		
		if jump then state_machine_start_state(superstateMachine, "movement", "jumping");
			
		// Controlling how high the jump can go based on holding the jump key
		if physics.vsp < -9 and !(inputs.jump[HELD] or tilemap_get_at_pixel(jumppoint, bbox_right, bbox_bottom)) then physics.vsp = -9;
		
		// Smoke Particles when landing
		if physics.onGround and !physics.onGroundPrevious {
			if !visuals.skipNextGroundSmokeEffect instance_create_layer(x-5, bbox_bottom, "Particles", oJumpSmokeParticle);
			visuals.skipNextGroundSmokeEffect = false;
		}
		
		
		
		#endregion --------------------------------------------------------------------------------------------------------------
		
		#region Animations ------------------------------------------------------------------------------------------------------
		image_speed = 1;
		
		if physics.onGround {
			if round(physics.hsp) != 0 {
				sprite_index = spr.walking;
				image_yscale = 1;
				image_xscale = 1 * physics.dir;
			} else {
				sprite_index = spr.standing;
				image_yscale = 1;
				image_xscale = 1 * physics.dir;
			}
			
		} else if !physics.onGround {
			if physics.vsp > 0 {
				sprite_index = spr.falling;
				image_yscale = 1 + abs(physics.vsp)/20;
				image_xscale = 0.9 * physics.dir;
			} else if physics.vsp > -5 {
				sprite_index = spr.jumping;
				image_index = 1;
				image_yscale = 1 + abs(physics.vsp)/20;
				image_xscale = 0.9 * physics.dir;
			} else {
				sprite_index = spr.jumping;
				image_index = 0;
				image_yscale = 1 + abs(physics.vsp)/20;
				image_xscale = 0.9 * physics.dir;
			}
		}
		
		#endregion
		
}

stateFunc[STATES.finish] = function() {} // Finish Walking (EMPTY)

state = state_create("walking", stateFunc[STATES.start], stateFunc[STATES.step], stateFunc[STATES.finish]);
state_machine_add_state(movementStateMachine, state);

#endregion

#region Jumping

stateFunc[STATES.start] = function() { // Start Jumping
	physics.vsp = -8;
			
	// VFX for jumping
	instance_create_layer(x-5,bbox_bottom+3,"Particles",oJumpSmokeParticle)
	//shockwave(x,bbox_bottom,10,10,spr_shockwave_distortion_normals_256,random_range(0.1,0.2))

	state_machine_end_state(superstateMachine, "movement");
} 

stateFunc[STATES.step] = function() {} // Step Jumping (EMPTY)

stateFunc[STATES.finish] = function() {} // Finish Jumping (EMPTY)

state = state_create("jumping", stateFunc[STATES.start], stateFunc[STATES.step], stateFunc[STATES.finish]);
state_machine_add_state(movementStateMachine, state);

#endregion

// Adding the superstate into the superstate machine
superstate_machine_set_state(superstateMachine, playerSuperstate[PLAYER_SUPERSTATES.inTown]);

// Starting the player running
state_machine_start_state(superstateMachine, "movement", "walking");

#endregion 

#region In Combat SUPERSTATE ----------------------------------------------------------------------#

playerSuperstate[PLAYER_SUPERSTATES.inCombat] = superstate_create();

// State machine for running, jumping, etc...
movementStateMachine = state_machine_create("movement");
superstate_add_state_machine(playerSuperstate[PLAYER_SUPERSTATES.inCombat], movementStateMachine);

// State machine for shielding
shieldStateMachine = state_machine_create("shield");
superstate_add_state_machine(playerSuperstate[PLAYER_SUPERSTATES.inCombat], shieldStateMachine);

#region Walking

var state, stateFunc;

stateFunc[STATES.start] = function() {} // Start Walking (EMPTY)

stateFunc[STATES.step] = function() { // Step Walking
		// Movement Defintions
		if !inputs.dir then physics.hsp = lerp(physics.hsp, 0, 0.3);
		
		physics.dir = 1;
		
		physics.hacc = 1; // Walking left and right
		physics.vacc = physics.grav;
		
		physics.maxvsp = 5;
		physics.minvsp = -20;
		
		if physics.vsp < 0 { // Having higher speeds while jumping
			physics.maxhsp = (2 + sqrt(abs(physics.vsp))/2);
			physics.minhsp = -physics.maxhsp;
		} else {	
			physics.maxhsp = 2;
			physics.minhsp = -physics.maxhsp;
		}
		
		if physics.onGround and physics.vsp > 0 then physics.vsp = 0 // Sticking to the ground and not gaining speed
			
		// Controlling how high the jump can go based on holding the jump key
		if physics.vsp < -7 and !(inputs.jump[HELD] or tilemap_get_at_pixel(jumppoint,bbox_right,bbox_bottom-5)) then physics.vsp = -7;
		
		// Smoke Particles when landing
		if physics.onGround and !physics.onGroundPrevious then instance_create_layer(x+3,bbox_bottom+3,"Particles",oJumpSmokeParticle);
		
		// Animations
		image_speed = 1;
		
		if physics.onGround { // While on the ground
			if round(physics.hsp) != 0 {
				sprite_index = spr.walking;
				image_yscale = 1;
				image_xscale = 1 * physics.dir;
			} else {
				sprite_index = spr.standing;
				image_yscale = 1;
				image_xscale = 1 * physics.dir;
			}
			
		} 
		
		else if !physics.onGround { // While in the air
			if physics.vsp > 0 {
				sprite_index = spr.falling;
				image_yscale = 1 + abs(physics.vsp)/20;
				image_xscale = 0.9 * physics.dir;
			} else if physics.vsp > -5 {
				sprite_index = spr.jumping;
				image_index = 1;
				image_yscale = 1 + abs(physics.vsp)/20;
				image_xscale = 0.9 * physics.dir;
			} else {
				sprite_index = spr.jumping;
				image_index = 0;
				image_yscale = 1 + abs(physics.vsp)/20;
				image_xscale = 0.9 * physics.dir;
			}
		}
		
		// State Transitions
		
		if inputs.spell[0][PRESSED] and playerStats.currentMana >= 1.5 { // Fireball
			state_machine_start_state(superstateMachine, "movement", "fireball");
		}
		
		else if inputs.spell[1][PRESSED] and playerStats.currentMana >= 1 { // Dashing
			state_machine_start_state(superstateMachine, "movement", "dashing");
		}
		
		else if inputs.spell[2][PRESSED] and
		playerStats.currentMana >= 3 and
		state_machine_get_current_state(shieldStateMachine) == undefined { // Shield Spell
			state_machine_start_state(superstateMachine, "shield", "shielding");
		}
		
		else { // Jumping
			if inputs.jump[HELD] then alarm[3] = 3;
			var jump = physics.onGround and (alarm[3] > 0 or tilemap_get_at_pixel(jumppoint, bbox_right, bbox_bottom - 5));
		
			if jump then state_machine_start_state(superstateMachine, "movement", "jumping");
		}
		
		// Attacking
		#region Finding an enemy
		ds_list_clear(enemyList);
		instance_place_list(x, y, oEnemyParent, enemyList, false);
		var enemy = noone;
		var i;
		for (i = 0; i < ds_list_size(enemyList); i++) {
			if enemyList[|i].enemyStats.canBeAttacked && enemyList[|i].enemyStats.canBeMeleed then enemy = enemyList[|i];
		}
		#endregion
		if  (alarm[1] <= 0 // Melee Cooldown
		and enemy != noone // Checking if any enemy was found
		and instance_exists(enemy) // Enemy got found
		and enemy.enemyStats.canBeAttacked // Enemy should be hit
		and enemy.enemyStats.canBeMeleed) { // Enemy hasn't been meleed
			state_machine_start_state(superstateMachine, "movement", "attacking");
			enemy.enemyStats.canBeMeleed = false;
		}
		
}

stateFunc[STATES.finish] = function() {} // Finish Walking (EMPTY)

state = state_create("walking", stateFunc[STATES.start], stateFunc[STATES.step], stateFunc[STATES.finish]);
state_machine_add_state(movementStateMachine, state);

#endregion

#region Jumping

stateFunc[STATES.start] = function() { // Start Jumping
	physics.vsp = -10;
		
	// VFX for jumping
	instance_create_layer(x-5,bbox_bottom+3,"Particles",oJumpSmokeParticle)
	//shockwave(x,bbox_bottom,10,10,spr_shockwave_distortion_normals_256,random_range(0.1,0.2))
	state_machine_end_state(superstateMachine, "movement");

} 

stateFunc[STATES.step] = function() {} // Step Jumping (EMPTY)

stateFunc[STATES.finish] = function() {} // Finish Jumping (EMPTY)

state = state_create("jumping", stateFunc[STATES.start], stateFunc[STATES.step], stateFunc[STATES.finish]);
state_machine_add_state(movementStateMachine, state);

#endregion

#region Attacking

stateFunc[STATES.start] = function() { // Start Attacking
	// Creating Hitbox
	meleeHitbox = create_hitbox(x-14, y-23, 45, 60, oEnemyParent, 60, meleeHit);
	
	// Physics Setup
	physics.maxhsp = 3;
	physics.minhsp = -1.5;

	physics.maxvsp = 5;
	physics.minvsp = -20;

	physics.vsp = max(min(0,physics.vsp),-5);
	physics.hsp = 0.5;
	
	physics.vacc = physics.grav;
	
	// Animations Setup
	sprite_index = spr.attacking;
	image_index = 0;
	image_speed = 1;
	
	// Attack Cooldown
	alarm[1] = 20;
	
	// Sync animation ending with state ending
	triggerFinishAttacking = false;

} 

stateFunc[STATES.step] = function() { // Step Attacking
	// Carrying hitbox around
	if instance_exists(meleeHitbox) {
		meleeHitbox.x = x-14;
		meleeHitbox.y = y-23;
	}
	
	// Physics
	physics.hacc = 0.25;
	
	// Animations
	image_xscale = 1;
	image_yscale = 1;
	
	// Transitioning States
	if triggerFinishAttacking { // Finish Attacking Normally
		state_machine_end_state(superstateMachine, "movement");
	
	} else if inputs.spell[1][PRESSED] and playerStats.currentMana >= 1  { // Cancel to dash
		state_machine_queue_state(superstateMachine, "movement", "dashing");
		state_machine_end_state(superstateMachine, "movement");
	
	} else if inputs.spell[0][PRESSED] and playerStats.currentMana >= 1.5 { // Cancel to fireball	
		state_machine_queue_state(superstateMachine, "movement", "fireball");
		state_machine_end_state(superstateMachine, "movement");
	
	} else if inputs.spell[2][PRESSED] and
	playerStats.currentMana >= 3 and 
	state_machine_get_current_state(shieldStateMachine) == undefined { // Cancel to shield	
		state_machine_start_state(superstateMachine, "shield", "shielding");

	} else { // Interrupt for jump
		if inputs.jump[HELD] then alarm[3] = 3;
		var jump = physics.onGround and (alarm[3] > 0 or tilemap_get_at_pixel(jumppoint, bbox_right, bbox_bottom - 5));
		
		if jump then state_machine_start_state(superstateMachine, "movement", "jumping");
	}
	
	
} 

stateFunc[STATES.finish] = function() { // Finish Attacking
	// Cleaning up hitbox
	if instance_exists(meleeHitbox) then instance_destroy(meleeHitbox);
} 

state = state_create("attacking", stateFunc[STATES.start], stateFunc[STATES.step], stateFunc[STATES.finish]);
state_machine_add_state(movementStateMachine, state);

#endregion

#region Dashing

stateFunc[STATES.start] = function() { // Start Dashing
	
	// Reset Melee
	reset_melee_for_all_enemies();
	
	// Drain Mana Cost
	add_player_mana(-1);
	
	// Physics Definitions
	physics.hsp = 12;
	
	// Animations
	sprite_index = spr.walking;
	
	// Visual Effects
	shockwave(x, bbox_bottom, 45, 2, spr_shockwave_distortion_normals_256, random_range(1.1,1.4));
	screenshake(2,3);
	alarmDash = 10; // Starting Dashing Effects
} 

stateFunc[STATES.step] = function() { // Step Dashing
	
	// Physics Definitions
	physics.hacc = -1;
	physics.maxhsp = 12;
	physics.vsp = 0;
	physics.vacc = 0;
	
	// Visual Effects
	switch alarmDash {
			case 10: { // First Frame
				instance_create_layer(x,y,"Particles",oDashParticles);
				if physics.onGround then instance_create_layer(x+3,y+10,"Particles",oSideSmokeParticle);
				var o = instance_create_layer(x-3,y+random_range(-2,2),"Particles",oPlayerShadowParticle);
					o.image_xscale = image_xscale;
					o.image_yscale = image_yscale;
					o.sprite_index = spr.walking;
					o.image_index = image_index;
					o.xSpd = 0.5;
			break
			}
			
			case 7: { // Fourth Frame
				var o = instance_create_layer(x,y,"Particles",oDashParticles);
					o.image_xscale = 0.8;
					o.image_yscale = 0.8;
					o.image_speed = 1.2;
					
				var o = instance_create_layer(x-3,y+random_range(-2,2),"Particles",oPlayerShadowParticle);
					o.image_xscale = image_xscale;
					o.image_yscale = image_yscale;
					o.sprite_index = spr.walking;
					o.image_index = image_index;
					o.xSpd = 0.75;
					
				if physics.onGround then instance_create_layer(x+3,y+10,"Particles",oSideSmokeParticle);
			break; }
			
			case 4: { // Seventh Frame
				var o = instance_create_layer(x,y,"Particles",oDashParticles);
					o.image_xscale = 0.6;
					o.image_yscale = 0.6;
					o.image_speed = 1.4;
					
				var o = instance_create_layer(x-3,y+random_range(-2,2),"Particles",oPlayerShadowParticle);
					o.image_xscale = image_xscale;
					o.image_yscale = image_yscale;
					o.sprite_index = spr.walking;
					o.image_index = image_index;
					o.xSpd = 1;
					
				if physics.onGround then instance_create_layer(x+3,y+10,"Particles",oSideSmokeParticle);
			
			break; }
		}
	
	// Stretching Character based on Speed
	image_xscale = 1 + abs(physics.hsp/8);
	image_yscale = 1.3 - abs(physics.hsp/12);
	
	// Particles
	var dashParticleCount = alarmDash/10;
	
	part_emitter_region(global.part_system_normal, emitter1, x + 10, x - 10, y + 10, y - 10, ps_shape_ellipse, ps_distr_linear);
	part_emitter_burst(global.part_system_normal, emitter1, particlesMana1, 21*dashParticleCount);
	part_emitter_burst(global.part_system_normal, emitter1, particlesMana2, 5*dashParticleCount);
	part_emitter_burst(global.part_system_normal, emitter1, particlesMana3, 3*dashParticleCount);
	
	// Affecting Snow Particles (TUNDRA ONLY)
	if (room == rTundra) {
		var previousXScale = image_xscale;
		var previousYScale = image_yscale;
		image_xscale = 7;
		image_yscale = 7;
		
		ds_list_clear(snowParticlesAffected);
		instance_place_list(x, y, oFallingSnowParticle, snowParticlesAffected, false);
		
		var i;
		for (i = ds_list_size(snowParticlesAffected) - 1; i >= 0; i--) {
			var particle = snowParticlesAffected[|i];
			var particleSpd = physics.hsp * max(0, (100 - point_distance(x, y, particle.x, particle.y)) / 100);
			
			particle.windXSpd = max(particle.windXSpd,  lerp(particleSpd, 0, 0.7));
		}
	
		
		image_xscale = previousXScale;
		image_yscale = previousYScale;
	}
	
	// Reducing the dash's timer
	alarmDash--;
	
	// Finishing
	if alarmDash <= 1 {
		state_machine_end_state(superstateMachine, "movement");
	}
	
	// Cancelling
	if inputs.jump[HELD] then alarm[3] = 3;
	var jump = physics.onGround and (alarm[3] > 0 or tilemap_get_at_pixel(jumppoint, bbox_right, bbox_bottom - 5));
	
	if jump { // Cancel to Jump 
		state_machine_queue_state(superstateMachine, "movement", "jumping");
		state_machine_end_state(superstateMachine, "movement");
	
		return;
	}
	
	#region Finding an enemy
	ds_list_clear(enemyList);
	instance_place_list(x, y, oEnemyParent, enemyList, false);
	var enemy = noone;
	var i;
	for (i = 0; i < ds_list_size(enemyList); i++) {
		if enemyList[|i].enemyStats.canBeAttacked && enemyList[|i].enemyStats.canBeMeleed then enemy = enemyList[|i];
	}
	#endregion
	
	if  (alarmDash <= 8 // Cancel to melee
	and alarm[1] <= 0 // Melee Cooldown
	and enemy != noone
	and instance_exists(enemy) // Enemy got found
	and enemy.enemyStats.canBeAttacked // Enemy should be hit
	and enemy.enemyStats.canBeMeleed) { // Enemy hasn't been meleed
		state_machine_queue_state(superstateMachine, "movement", "attacking");
		state_machine_end_state(superstateMachine, "movement");
		enemy.enemyStats.canBeMeleed = false;	
		return;
	}
} 

stateFunc[STATES.finish] = function() { // Finish Dashing

} 

state = state_create("dashing", stateFunc[STATES.start], stateFunc[STATES.step], stateFunc[STATES.finish]);
state_machine_add_state(movementStateMachine, state);

#endregion

#region Fireball

stateFunc[STATES.start] = function() { // Start fireball
	// Reset Melee
	reset_melee_for_all_enemies();
	
	// Drain Mana Cost
	add_player_mana(-1.5);
	
	// Physics Definitions
	physics.hsp -= 20;
	physics.vsp = min(physics.vsp, -3);
	
	// Create Fireball
	instance_create_layer(x, y, "Particles", oFireball);
	
	// Finish State
	state_machine_end_state(superstateMachine, "movement");

} 

stateFunc[STATES.step] = function() {} // Step Fireball (EMPTY)

stateFunc[STATES.finish] = function() {} // Finish Fireball (EMPTY)

state = state_create("fireball", stateFunc[STATES.start], stateFunc[STATES.step], stateFunc[STATES.finish]);
state_machine_add_state(movementStateMachine, state);

#endregion

#region Shielding

stateFunc[STATES.start] = function() { // Start shielding
	// Drain Mana Cost
	add_player_mana(-3);
	
	// Create Object
	if !instance_exists(oShieldBubble) then shieldBubble = instance_create_layer(x, y, "Particles", oShieldBubble);
	shieldTimer = 900;
	
	// Create Particles
	
	
	// VFX
	
} 

stateFunc[STATES.step] = function() { // Step Shielding (EMPTY)
	
	// Count Down Shield Timer
	shieldTimer --;
	if shieldTimer <= 0 then state_machine_end_state(superstateMachine, "shield");
} 

stateFunc[STATES.finish] = function() { // Finish Shielding (EMPTY)
	
	// Destroy Shield
	instance_destroy(oShieldBubble);
	shieldTimer = 0;
	
	// Heal and explode based on how early the shield was cancelled
	
	
	// VFX
	
	
} 

state = state_create("shielding", stateFunc[STATES.start], stateFunc[STATES.step], stateFunc[STATES.finish]);
state_machine_add_state(shieldStateMachine, state);

#endregion

#endregion

#endregion

#region Components

inputs = { // Input Related Attributes
	jump: false,
	left: false,
	right: false,
	dir: 0,
	mbLeft: false,
	attack: false,
	interact: false,
} 

function inputs_component(inputs) { // Processing the inputs
	inputs.jump = input(vk_space);
	inputs.left = input(ord("A"));
	inputs.right = input(ord("D"));
	inputs.attack = input(ord("C"));
	inputs.spell[0] = input(ord("Q"));
	inputs.spell[1] = input(vk_shift);
	inputs.spell[2] = input(ord("E"));
	inputs.interact = input(ord("S"));
	
	inputs.dir = inputs.right[HELD] - inputs.left[HELD];

	inputs.mbLeft = input(mb_left);
	inputs.mbRight = input(mb_right);
	
	return inputs;
}

physics = { // Movement Related Attributes
	// Speed
	hsp : 0,
	vsp : 0,

	// Accelaration
	hacc : 0,
	vacc : 0,

	// If the entity is touching the ground
	onGround : false,
	onGroundPrevious: false,

	// Gravity Values
	grav: 0.55,
	
	// Max Speeds:
	maxhsp: 0,
	minhsp: 0,
	
	maxvsp: 0,
	minvsp: 0,
	
	// Direction:
	dir: 1,
	
	// Bounding Boxes:
	bbox_h: 0,
	bbox_v: 0,
	
	// Collision Flags:
	horizontalCollision: false,
	verticalCollision: false,
}

function physics_component(mov) { // Processing the physics 
	// Increase HSP and VSP based on HACC and VACC
	mov.hsp += mov.hacc;
	mov.vsp += mov.vacc;

	// Clamping Maximum Speeds
	mov.hsp = clamp(mov.hsp, mov.minhsp, mov.maxhsp);
	mov.vsp = clamp(mov.vsp, mov.minvsp, mov.maxvsp);
	
	// Store xscale and yscale values so collsion can be calculated with a proper image
	mov.image_xscale_real = image_xscale;
	mov.image_yscale_real = image_yscale;
	image_xscale = 1 * mov.dir;
	image_yscale = 1;

	// Which side of the character to be checking for collision
	if mov.hsp > 0 then mov.bbox_h = bbox_right else mov.bbox_h = bbox_left;
	if mov.vsp >= 0 then mov.bbox_v = bbox_bottom else mov.bbox_v = bbox_top;
	
	var h,v // Floor Numbers so that when hsp = 0.4 the player doesn't actually move but precision is kept
	h = floor(abs(mov.hsp));
	v = floor(abs(mov.vsp));
	
	while (h + v > 0) { // While there is still any movement to be done, do it
			
		if h > 0 { // Horizontal Part
			var currentX = x;
			
			x += sign(mov.hsp);
			
			var right	= bbox_right;
			var left	= bbox_left;
			var bottom	= bbox_bottom;
			var top		= bbox_top;
			
			x = currentX;
			
			if  !tilemap_get_at_pixel(tilemap, left , bottom)
			and !tilemap_get_at_pixel(tilemap, right, bottom)
			and !tilemap_get_at_pixel(tilemap, left,  top) 
			and !tilemap_get_at_pixel(tilemap, right, top) {
				x += sign(mov.hsp);
				h --;
				mov.horizontalCollision = false;
				
			} else {
				mov.horizontalCollision = true;
				h = 0;
			}
		}
	
		if v > 0 { // Vertical Part
			var currentY = y;
			
			y += sign(mov.vsp);
			
			var right	= bbox_right;
			var left	= bbox_left;
			var bottom	= bbox_bottom;
			var top		= bbox_top;
			
			y = currentY;
			
			if  !tilemap_get_at_pixel(tilemap, left , bottom)
			and !tilemap_get_at_pixel(tilemap, right, bottom)
			and !tilemap_get_at_pixel(tilemap, left,  top) 
			and !tilemap_get_at_pixel(tilemap, right, top) {
				y += sign(mov.vsp);
				v --;
				mov.verticalCollision = false;
				
			} else {
				v = 0;
				mov.verticalCollision = true;
			}
		}
		
	}
	
	#region Decimal Part
	var hDecimal = abs(mov.hsp % 1);
	var vDecimal = abs(mov.vsp % 1);

	if hDecimal > 0 { // Horizontal Part
	    var currentX = x;
	    
		x += sign(mov.hsp) * hDecimal;
	    
		var right	= bbox_right;
		var left	= bbox_left;
		var bottom	= bbox_bottom;
		var top		= bbox_top;
	    
		x = currentX;
    
	    if  !tilemap_get_at_pixel(tilemap, left , bottom)
		and !tilemap_get_at_pixel(tilemap, right, bottom)
		and !tilemap_get_at_pixel(tilemap, left,  top) 
		and !tilemap_get_at_pixel(tilemap, right, top) {
			x += sign(mov.hsp) * hDecimal;
			mov.horizontalCollision = false;
		} else {
			mov.horizontalCollision = true;
		}
	}

	if vDecimal > 0 { // Vertical Part
	    var currentY = y;
	    
		y += sign(mov.vsp) * vDecimal;
	    
		var right	= bbox_right;
		var left	= bbox_left;
		var bottom	= bbox_bottom;
		var top		= bbox_top;
	    
		y = currentY;
    
	    if  !tilemap_get_at_pixel(tilemap, left , bottom)
		and !tilemap_get_at_pixel(tilemap, right, bottom)
		and !tilemap_get_at_pixel(tilemap, left,  top) 
		and !tilemap_get_at_pixel(tilemap, right, top) {
			y += sign(mov.vsp) * vDecimal;
			mov.verticalCollision = false;
		} else {
			mov.verticalCollision = true;
		}
	}
		
	#endregion

	// Check if the player player is touching the ground
	mov.onGroundPrevious = mov.onGround;
	mov.onGround = !(tilemap_get_at_pixel(tilemap, bbox_right, mov.bbox_v + sign(mov.vsp) + 1) = 0 
	and tilemap_get_at_pixel(tilemap, bbox_left, mov.bbox_v + sign(mov.vsp) + 1) = 0);

	// Restore xscale and yscale to their original values for visual purposes
	image_xscale = mov.image_xscale_real;
	image_yscale = mov.image_yscale_real;
	
}
	
visuals = { // Visuals Related Attributes
	//NOTE: For simplicity purporses, built-in variables don't go here
	
	// Alpha effect
	colConfig: col_sprite_create(c_white, 0, bm_add),
	
	// Mostly used for room transitions - doesn't spawn the next smoke effect
	skipNextGroundSmokeEffect: true,
	
}

function visual_component(visuals) { // Processing the visuals (done in the draw event)
	// Player Shadow
	if physics.onGround then draw_sprite_ext(spr.shadow, 0, x, bbox_bottom + 2, 1, 1, 0, c_white, 0.4);

	// Player Sprite
	draw_self();
	
	// White Alpha Effect
	col_sprite_add_alpha(visuals.colConfig, -0.05)
	col_sprite_draw_obj(visuals.colConfig, self);
	
}

sounds = {} // Sound Related Attributes

function sound_component(sounds) {} // Processing the sounds

function update_step() { // Stuff that can be done in the step event
	inputs_component(inputs);
	physics_component(physics);
	sound_component(sounds);
}

function update_draw() { // Stuff that needs to be done in the draw event
	visual_component(visuals);
}

#endregion

#region Sprites
spr = {
	attacking: sPlayerAttacking,
	falling: sPlayerFalling,
	hitbox: sPlayerHitbox,
	jumping: sPlayerJumping,
	shadow: sPlayerShadow,
	walking: sPlayerWalking,
	standing: sPlayerStanding,
};

#region Spells
	shieldTimer = 0;

#endregion

#endregion

#region Reading Hits

hitsTaken = ds_list_create();

#endregion

#region Snow Particles

snowParticlesAffected = ds_list_create();

#endregion

#region Hit Effects

// Enemies Found List
enemyList = ds_list_create();

#endregion

#region Functions for using in Hit Effects
function get_damaged(damage) {
	if instance_exists(oShieldBubble) then oShieldBubble.shake_bubble();
	add_player_hp(-damage);
}

#endregion

#region Other
// Collision Tilemaps
tilemap = layer_tilemap_get_id("Collision");
jumppoint = layer_tilemap_get_id("JumpPoints");

mask_index = spr.walking; // Hitbox

// Image Scale real values
image_xscale_real = image_xscale;
image_yscale_real = image_yscale;

// Coordinates that camera follows
xForCamera = x;
yForCamera = y;

xForCameraOffset = 0;
yForCameraOffset = 0;

hitboxArray = [false]; // Array used for taking damage

itemsPickedUpList = ds_list_create(); // Picking Up Items

var _fps = game_get_speed(gamespeed_fps);



// Reset Melee
function reset_melee_for_all_enemies() {
	with oEnemyParent {
		enemyStats.canBeMeleed = true;
	}
}

#endregion

#region New Particle System

	#region Dash Particles
particlesMana1 = part_type_create(); // Mana Sprinkles
part_type_speed(particlesMana1, 2, 3, -0.2, 0);
part_type_direction(particlesMana1, 90, 270, 0, 0);
part_type_gravity(particlesMana1, 0.03, 270);
part_type_orientation(particlesMana1, 0, 360, 2, 5, 0);
part_type_size(particlesMana1, 0.10, 0.40, -0.02, 0.2);
part_type_scale(particlesMana1, 0.1, 0.1);
part_type_life(particlesMana1, 0.3 * _fps, 0.6 * _fps);
part_type_blend(particlesMana1, true);
part_type_color_mix(particlesMana1, 16773388, 16370944);
part_type_alpha2(particlesMana1, 1, 0);
part_type_shape(particlesMana1, pt_shape_square);

particlesMana2 = part_type_create(); // Mana Bubbles
part_type_speed(particlesMana2, 0.5, 1.5, -0.02, 0);
part_type_direction(particlesMana2, 180, 180, 1, 3);
part_type_orientation(particlesMana2, 0, 360, 1, 10, 0);
part_type_size(particlesMana2, 0.20, 1.20, -0.02, 0);
part_type_scale(particlesMana2, 0.16, 0.12);
part_type_life(particlesMana2, 1 * _fps, 2 * _fps);
part_type_blend(particlesMana2, true);
part_type_color3(particlesMana2, $fff10c, $f9cd00, $dc9800);
part_type_alpha2(particlesMana2, 1,0);
part_type_shape(particlesMana2, pt_shape_ring);

particlesMana3 = part_type_create(); // Mana Sprinkles
part_type_speed(particlesMana3, 4, 5, -0.3, 0.3);
part_type_direction(particlesMana3, 90, 270, 5, 10);
part_type_gravity(particlesMana3, 0.05, 90);
part_type_orientation(particlesMana3, 0, 360, 10, 20, 0);
part_type_size(particlesMana3, 0.10, 0.40, -0.001, 0.1);
part_type_scale(particlesMana3, 0.1, 0.1);
part_type_life(particlesMana3, 1.5 * _fps, 1.75 * _fps);
part_type_blend(particlesMana3, true);
part_type_color_mix(particlesMana3, 16773388, 16370944);
part_type_alpha2(particlesMana3, 1, 0);
part_type_shape(particlesMana3, pt_shape_square);
#endregion

	#region Melee Hit Particles
particlesMeleeHit1 = part_type_create();
part_type_speed(particlesMeleeHit1, 2, 6, -0.2, 0);
part_type_direction(particlesMeleeHit1, -10, 45, 0, 0);
part_type_gravity(particlesMeleeHit1, 0.07, 270);
part_type_orientation(particlesMeleeHit1, 0, 360, 1, 10, 0);
part_type_size(particlesMeleeHit1, 0.20, 0.90, -0.02, 0.1);
part_type_scale(particlesMeleeHit1, 0.16, 0.12);
part_type_life(particlesMeleeHit1, 0.3 * _fps, 0.6 * _fps);
part_type_blend(particlesMeleeHit1, true);
part_type_color_mix(particlesMeleeHit1, c_white, c_white);
part_type_alpha1(particlesMeleeHit1, 1);
part_type_shape(particlesMeleeHit1, pt_shape_ring);

particlesMeleeHit2 = part_type_create();
part_type_speed(particlesMeleeHit2, 2, 6, -0.3, 0);
part_type_direction(particlesMeleeHit2, 0, 65, 0, 0);
part_type_gravity(particlesMeleeHit2, 0.25, 270);
part_type_orientation(particlesMeleeHit2, 0, 360, 1, 10, 0);
part_type_size(particlesMeleeHit2, 0.30, 0.40, -0.02, 0.3);
part_type_scale(particlesMeleeHit2, 0.16, 0.12);
part_type_life(particlesMeleeHit2, 0.4 * _fps, 0.5 * _fps);
part_type_blend(particlesMeleeHit2, true);
part_type_color_mix(particlesMeleeHit2, c_white, c_white);
part_type_alpha1(particlesMeleeHit2, 1);
part_type_shape(particlesMeleeHit2, pt_shape_sphere);

particlesMeleeHit3 = part_type_create();
part_type_speed(particlesMeleeHit3, 0.5, 0.5, -0.01, 0);
part_type_direction(particlesMeleeHit3, 0, 360, 0, 0);
part_type_orientation(particlesMeleeHit3, 0, 360, 1, 10, 0);
part_type_size(particlesMeleeHit3, 0.20, 0.80, -0.02, 0);
part_type_scale(particlesMeleeHit3, 0.16, 0.12);
part_type_life(particlesMeleeHit3, 0.3 * _fps, 0.4 * _fps);
part_type_blend(particlesMeleeHit3, true);
part_type_color3(particlesMeleeHit3, c_white, $ddcfc7, $b9a192);
part_type_alpha2(particlesMeleeHit3, 0.3,0);
part_type_shape(particlesMeleeHit3, pt_shape_sphere);
#endregion

// Emitters
emitter1 = part_emitter_create(global.part_system_normal);
part_emitter_region(global.part_system_normal, emitter1, x,x,y,y, ps_shape_ellipse, ps_distr_linear);
part_emitter_stream(global.part_system_normal, emitter1, particlesMana1, 0);

#endregion

#region Melee Hit Effects

// Generating the melee hit
meleeHit = {};
meleeHit.vars = {
	damage: 10,
	emitter1: emitter1,
	particlesMeleeHit1: particlesMeleeHit1,
	particlesMeleeHit2: particlesMeleeHit2,
	particlesMeleeHit3: particlesMeleeHit3,
};

meleeHit.vars.attacker = self;

meleeHit.apply_effects = function(vars, entityHit) { // The function that runs when the enemy is hit
	vars.entityHit = entityHit;
	
	with entityHit var func = function(vars) {
		// Calculating FX Intensity
		var hitImpact = min(max(vars.damage/get_max_hp(), 0.95), 1.2);
		
		// Applying Damage
		get_damaged(vars.damage * random_range(0.9,1.1));
		
		// Creating Floating Text
		floating_text(x, y, vars.damage + round(random_range(0,10)), global.fontHopeWhite);
	
		// HP Bar Stuff
		alarm[3] = 3; // Resetting Speed for Yellow Part of HP Bar
		visuals.hpBarShake = hitImpact * 4; // Making the HP Bar shake
	
		// Screenshake and Freeze Effect
		screenshake(4*hitImpact, 3);
		screenfreeze(40*hitImpact);
	
		// White Alpha Effect
		col_sprite_set_blendmode(visuals.colConfig, bm_add);
		col_sprite_set_alpha(visuals.colConfig, 1.2);
		col_sprite_set_col(visuals.colConfig, c_white);
		
		// Enemy Sprite Shaking
		visuals.xShake = random_range(-1.5, 1.5);
		visuals.yShake = random_range(-1.5, 1.5);
		visuals.xScaleShake = random_range(-0.1, 0.1);
		visuals.yScaleShake = random_range(-0.1, 0.1);
		
		// Knocking Back Attacker
		vars.attacker.physics.hsp = vars.attacker.physics.dir;
		
		// Knockback
		physics.hsp += hitImpact;
		
		// Giving the Player Mana
		add_player_mana(min(vars.damage/get_max_hp(), 1) * 1.25);
		
		// Visual Effects
		var o = instance_create_depth(x+random_range(-1,1), y+random_range(-1,1), depth-1, oHitEffect1)
		o.xscale1 = random_range(0.7,1.2) * hitImpact * get_effects_size();
		o.yscale1 = random_range(0.7,1.2) * hitImpact * get_effects_size();
		o.xscale2 = random_range(0.7,1.2) * hitImpact * get_effects_size();
		o.yscale2 = random_range(0.7,1.2) * hitImpact * get_effects_size();
		
		var o = instance_create_depth(x+random_range(-1,1), y+random_range(-1,1), depth-1 ,oHitEffect2)
		o.image_xscale = 0.45 * hitImpact * get_effects_size();
		o.image_yscale = 0.50 * hitImpact * get_effects_size();
		
		// Particles
		part_emitter_region(global.part_system_normal, vars.emitter1, x-5, x+5, y-5, y+5, ps_shape_ellipse, ps_distr_linear);
		part_emitter_burst(global.part_system_normal, vars.emitter1, vars.particlesMeleeHit1, 1.2 * min(80,80*(vars.damage / get_max_hp())) * get_effects_size());
		part_emitter_burst(global.part_system_normal, vars.emitter1, vars.particlesMeleeHit2, 1.2 * min(20,20*(vars.damage / get_max_hp())) * get_effects_size());

		part_emitter_region(global.part_system_normal, vars.emitter1, x, x, y, y, ps_shape_ellipse, ps_distr_linear);
		part_emitter_burst(global.part_system_normal, vars.emitter1, vars.particlesMeleeHit3, 600);
		
	}
	
	delay_function(entityHit, func, vars, 3);
}

#endregion

#region Old Particle System
global._part_system = part_system_create();
global._part_system_2 = part_system_create();

part_system_automatic_update(global._part_system, true);
part_system_automatic_draw(global._part_system, true);
var _fps = game_get_speed(gamespeed_fps);

/* Type 1 - Dash Particles */
global._part_type_1 = part_type_create();
part_type_speed(global._part_type_1, 2, 3, -0.2, 0);
part_type_direction(global._part_type_1, 90, 270, 0, 0);
part_type_gravity(global._part_type_1, 0.03, 270);
part_type_orientation(global._part_type_1, 0, 360, 2, 5, 0);
part_type_size(global._part_type_1, 0.10, 0.40, -0.02, 0.2);
part_type_scale(global._part_type_1, 0.1, 0.1);
part_type_life(global._part_type_1, 0.3 * _fps, 0.6 * _fps);
part_type_blend(global._part_type_1, true);
part_type_color_mix(global._part_type_1, 16773388, 16370944);
part_type_alpha2(global._part_type_1, 1, 0);
part_type_shape(global._part_type_1, pt_shape_square);

/* Emitter 1 - Dash Particles */
global._part_emitter_1 = part_emitter_create(global._part_system);
part_emitter_region(global._part_system, global._part_emitter_1, x,x,y,y, ps_shape_ellipse, ps_distr_linear);
part_emitter_stream(global._part_system, global._part_emitter_1,global._part_type_1,0)

/* Type 2 - Hit Particles 1 */
global._part_type_2 = part_type_create();
part_type_speed(global._part_type_2, 2, 6, -0.2, 0);
part_type_direction(global._part_type_2, -10, 45, 0, 0);
part_type_gravity(global._part_type_2, 0.07, 270);
part_type_orientation(global._part_type_2, 0, 360, 1, 10, 0);
part_type_size(global._part_type_2, 0.20, 0.90, -0.02, 0.1);
part_type_scale(global._part_type_2, 0.16, 0.12);
part_type_life(global._part_type_2, 0.3 * _fps, 0.6 * _fps);
part_type_blend(global._part_type_2, true);
part_type_color_mix(global._part_type_2, c_white, c_white);
part_type_alpha1(global._part_type_2, 1);
part_type_shape(global._part_type_2, pt_shape_ring);

/* Type 3 - Hit Particles 2 */
global._part_type_3 = part_type_create();
part_type_speed(global._part_type_3, 2, 6, -0.3, 0);
part_type_direction(global._part_type_3, 0, 65, 0, 0);
part_type_gravity(global._part_type_3, 0.25, 270);
part_type_orientation(global._part_type_3, 0, 360, 1, 10, 0);
part_type_size(global._part_type_3, 0.30, 0.40, -0.02, 0.3);
part_type_scale(global._part_type_3, 0.16, 0.12);
part_type_life(global._part_type_3, 0.4 * _fps, 0.5 * _fps);
part_type_blend(global._part_type_3, true);
part_type_color_mix(global._part_type_3, c_white, c_white);
part_type_alpha1(global._part_type_3, 1);
part_type_shape(global._part_type_3, pt_shape_sphere);

/* Emitter 2 - Hit Particles */
global._part_emitter_2 = part_emitter_create(global._part_system);
part_emitter_region(global._part_system, global._part_emitter_2, x,x,y,y, ps_shape_ellipse, ps_distr_linear);
part_emitter_stream(global._part_system, global._part_emitter_2,global._part_type_2,0)

/* Emitter 3 - Blue Skill Particles */
global._part_emitter_3 = part_emitter_create(global._part_system);
part_emitter_region(global._part_system, global._part_emitter_3, x,x,y,y, ps_shape_ellipse, ps_distr_linear);
part_emitter_stream(global._part_system, global._part_emitter_3,global._part_type_1,0)

/* Emitter 4 - Item Buy Particles */
global._part_emitter_4 = part_emitter_create(global._part_system_2);
part_emitter_region(global._part_system_2, global._part_emitter_4, x,x,y,y, ps_shape_ellipse, ps_distr_linear);
part_emitter_stream(global._part_system_2, global._part_emitter_4,global._part_type_1,0)

/* Type 4 - Blue Skill Particles */
global._part_type_4 = part_type_create();
part_type_speed(global._part_type_4, 0.5, 0.5, -0.01, 0);
part_type_direction(global._part_type_4, 0, 360, 0, 0);
part_type_orientation(global._part_type_4, 0, 360, 1, 10, 0);
part_type_size(global._part_type_4, 0.20, 0.80, -0.02, 0);
part_type_scale(global._part_type_4, 0.16, 0.12);
part_type_life(global._part_type_4, 1 * _fps, 1.3 * _fps);
part_type_blend(global._part_type_4, true);
part_type_color3(global._part_type_4, $cf6e52, $f6e14b, $55310b);
part_type_alpha2(global._part_type_4, 1,0);
part_type_shape(global._part_type_4, pt_shape_sphere);

/* Type 5 - Red Skill Particles */
global._part_type_5 = part_type_create();
part_type_speed(global._part_type_5, 0.5, 0.5, -0.01, 0);
part_type_direction(global._part_type_5, 0, 360, 0, 0);
part_type_orientation(global._part_type_5, 0, 360, 1, 10, 0);
part_type_size(global._part_type_5, 0.20, 0.80, -0.02, 0);
part_type_scale(global._part_type_5, 0.16, 0.12);
part_type_life(global._part_type_5, 1 * _fps, 1.3 * _fps);
part_type_blend(global._part_type_5, true);
part_type_color3(global._part_type_5, $9cfa71, $669000, $222f02);
part_type_alpha2(global._part_type_5, 1,0);
part_type_shape(global._part_type_5, pt_shape_sphere);

/* Type 6 - Green Skill Particles */
global._part_type_6 = part_type_create();
part_type_speed(global._part_type_6, 0.5, 0.5, -0.01, 0);
part_type_direction(global._part_type_6, 0, 360, 0, 0);
part_type_orientation(global._part_type_6, 0, 360, 1, 10, 0);
part_type_size(global._part_type_6, 0.20, 0.80, -0.02, 0);
part_type_scale(global._part_type_6, 0.16, 0.12);
part_type_life(global._part_type_6, 1 * _fps, 1.3 * _fps);
part_type_blend(global._part_type_6, true);
part_type_color3(global._part_type_6, $c58ffa, $490084, $2c0355);
part_type_alpha2(global._part_type_6, 1,0);
part_type_shape(global._part_type_6, pt_shape_sphere);

/* Type 7 - Blue Skill Particles BUBBLES ROUNDING */
global._part_type_7 = part_type_create();
part_type_speed(global._part_type_7, 1.5, 3, -0.045, 0.1);
part_type_direction(global._part_type_7, 0, 360, 6, 0);
part_type_orientation(global._part_type_7, 0, 360, 10, 10, 0);
part_type_size(global._part_type_7, 0.1, 1, -0.01, 0.2);
part_type_scale(global._part_type_7, 0.2, 0.12);
part_type_life(global._part_type_7, 1 * _fps, 1 * _fps);
part_type_blend(global._part_type_7, true);
part_type_color3(global._part_type_7, $cf6e52, $f6e14b, $55310b);
part_type_alpha2(global._part_type_7, 1,0);
part_type_shape(global._part_type_7, pt_shape_ring);

/* Type 8 - Blue Skill Particles BIGGER */
global._part_type_8 = part_type_create();
part_type_speed(global._part_type_8, 1, 1, -0.02, 0);
part_type_direction(global._part_type_8, 0, 360, 1, 0);
part_type_orientation(global._part_type_8, 0, 360, 1, 10, 0);
part_type_size(global._part_type_8, 0.20, 0.80, -0.02, 0.1);
part_type_scale(global._part_type_8, 0.16, 0.12);
part_type_life(global._part_type_8, 1 * _fps, 1.3 * _fps);
part_type_blend(global._part_type_8, true);
part_type_color3(global._part_type_8, $cf6e52, $f6e14b, $55310b);
part_type_alpha2(global._part_type_8, 1,0);
part_type_shape(global._part_type_8, pt_shape_sphere);

/* Type 10 - Green Skill Particles BIGGER */
global._part_type_10 = part_type_create();
part_type_speed(global._part_type_10, 1, 1.5, -0.02, 0);
part_type_direction(global._part_type_10, 180, 360, 0, 2);
part_type_orientation(global._part_type_10, 0, 360, 1, 10, 0);
part_type_size(global._part_type_10, 0.20, 0.80, -0.02, 0.1);
part_type_scale(global._part_type_10, 0.16, 0.12);
part_type_life(global._part_type_10, 0.7 * _fps, 0.8 * _fps);
part_type_blend(global._part_type_10, true);
part_type_color3(global._part_type_10, $9cfa71, $669000, $222f02);
part_type_alpha2(global._part_type_10, 1,0);
part_type_shape(global._part_type_10, pt_shape_square);

/* Type 9 - White Hit Circle Particles */
global._part_type_9 = part_type_create();
part_type_speed(global._part_type_9, 0.5, 0.5, -0.01, 0);
part_type_direction(global._part_type_9, 0, 360, 0, 0);
part_type_orientation(global._part_type_9, 0, 360, 1, 10, 0);
part_type_size(global._part_type_9, 0.20, 0.80, -0.02, 0);
part_type_scale(global._part_type_9, 0.16, 0.12);
part_type_life(global._part_type_9, 0.3 * _fps, 0.4 * _fps);
part_type_blend(global._part_type_9, true);
part_type_color3(global._part_type_9, c_white, $ddcfc7, $b9a192);
part_type_alpha2(global._part_type_9, 0.3,0);
part_type_shape(global._part_type_9, pt_shape_sphere);

/* Type 11 - Mana Particles */
global._part_type_11 = part_type_create();
part_type_speed(global._part_type_11, 0.5, 1.5, -0.02, 0);
part_type_direction(global._part_type_11, 180, 180, 0, 1);
part_type_orientation(global._part_type_11, 0, 360, 1, 10, 0);
part_type_size(global._part_type_11, 0.20, 0.80, -0.02, 0);
part_type_scale(global._part_type_11, 0.16, 0.12);
part_type_life(global._part_type_11, 1 * _fps, 2 * _fps);
part_type_blend(global._part_type_11, false);
part_type_color3(global._part_type_11, $fff10c, $f9cd00, $dc9800);
part_type_alpha2(global._part_type_11, 1,0);
part_type_shape(global._part_type_11, pt_shape_square);

/* Type 12 - Mana Particles Bubbles */
global._part_type_12 = part_type_create();
part_type_speed(global._part_type_12, 0.5, 1.5, -0.02, 0);
part_type_direction(global._part_type_12, 180, 180, 1, 3);
part_type_orientation(global._part_type_12, 0, 360, 1, 10, 0);
part_type_size(global._part_type_12, 0.20, 1.20, -0.02, 0);
part_type_scale(global._part_type_12, 0.16, 0.12);
part_type_life(global._part_type_12, 1 * _fps, 2 * _fps);
part_type_blend(global._part_type_12, false);
part_type_color3(global._part_type_12, $fff10c, $f9cd00, $dc9800);
part_type_alpha2(global._part_type_12, 1,0);
part_type_shape(global._part_type_12, pt_shape_ring);

/* Type 13 - White Hud Particles */
global._part_type_13 = part_type_create();
part_type_speed(global._part_type_13, 0.5, 2, -0.02, 0);
part_type_direction(global._part_type_13, 0, 360, 0, 1);
part_type_orientation(global._part_type_13, 0, 360, 1, 10, 0);
part_type_gravity(global._part_type_13,0.02,270)
part_type_size(global._part_type_13, 0.20, 0.80, -0.02, 0);
part_type_scale(global._part_type_13, 0.16, 0.12);
part_type_life(global._part_type_13, 1 * _fps, 2 * _fps);
part_type_blend(global._part_type_13, false);
part_type_color1(global._part_type_13, c_white);
part_type_alpha2(global._part_type_13, 1,0);
part_type_shape(global._part_type_13, pt_shape_square);

/* Type 14 - Grey Hud Particles */
global._part_type_14 = part_type_create();
part_type_speed(global._part_type_14, 0.5, 2, -0.02, 0);
part_type_direction(global._part_type_14, 0, 360, 0, 1);
part_type_orientation(global._part_type_14, 0, 360, 1, 10, 0);
part_type_gravity(global._part_type_14,0.02,270)
part_type_size(global._part_type_14, 0.20, 0.80, -0.02, 0);
part_type_scale(global._part_type_14, 0.16, 0.12);
part_type_life(global._part_type_14, 1 * _fps, 2 * _fps);
part_type_blend(global._part_type_14, false);
part_type_color1(global._part_type_14, $ddcfc7);
part_type_alpha2(global._part_type_14, 1,0);
part_type_shape(global._part_type_14, pt_shape_square);

/* Type 15 - White Death Particles BUBBLE ROUNDING*/
global._part_type_15 = part_type_create();
part_type_speed(global._part_type_15, 1.5, 3, -0.045, 0.1);
part_type_direction(global._part_type_15, 0, 360, 6, 0);
part_type_orientation(global._part_type_15, 0, 360, 10, 10, 0);
part_type_size(global._part_type_15, 0.1, 1, -0.01, 0.2);
part_type_scale(global._part_type_15, 0.2, 0.12);
part_type_life(global._part_type_15, 1 * _fps, 1 * _fps);
part_type_blend(global._part_type_15, true);
part_type_color3(global._part_type_15, c_white, c_white, c_white);
part_type_alpha2(global._part_type_15, 1,0);
part_type_shape(global._part_type_15, pt_shape_ring);

/* Type 16 - White Death Particles BIGGER */
global._part_type_16 = part_type_create();
part_type_speed(global._part_type_16, 1, 1, -0.02, 0);
part_type_direction(global._part_type_16, 0, 360, 1, 0);
part_type_orientation(global._part_type_16, 0, 360, 1, 10, 0);
part_type_size(global._part_type_16, 0.20, 0.80, -0.02, 0.1);
part_type_scale(global._part_type_16, 0.16, 0.12);
part_type_life(global._part_type_16, 1 * _fps, 1.3 * _fps);
part_type_blend(global._part_type_16, true);
part_type_color3(global._part_type_16, $cf6e52, $f6e14b, $55310b);
part_type_alpha2(global._part_type_16, 1,0);
part_type_shape(global._part_type_16, pt_shape_sphere);

/* Type 17 - Fireball Particles */
global._part_type_17 = part_type_create();
part_type_speed(global._part_type_17, 0.5, 1.5, -0.02, 0);
part_type_direction(global._part_type_17, 180, 180, 0, 1);
part_type_orientation(global._part_type_17, 0, 360, 1, 10, 0);
part_type_size(global._part_type_17, 0.20, 0.80, -0.02, 0);
part_type_scale(global._part_type_17, 0.16, 0.12);
part_type_life(global._part_type_17, 1 * _fps, 1.5 * _fps);
part_type_blend(global._part_type_17, true);
part_type_color3(global._part_type_17, $fff10c, $f9cd00, $dc9800);
part_type_alpha2(global._part_type_17, 1,0);
part_type_shape(global._part_type_17, pt_shape_square);

/* Type 18 - Ability Particles Bubbles */
global._part_type_18 = part_type_create();
part_type_speed(global._part_type_18, 0.5, 1.5, -0.02, 0);
part_type_direction(global._part_type_18, 180, 180, 1, 3);
part_type_orientation(global._part_type_18, 0, 360, 1, 10, 0);
part_type_size(global._part_type_18, 0.20, 1.20, -0.02, 0);
part_type_scale(global._part_type_18, 0.16, 0.12);
part_type_life(global._part_type_18, 1 * _fps, 2 * _fps);
part_type_blend(global._part_type_18, true);
part_type_color3(global._part_type_18, $fff10c, $f9cd00, $dc9800);
part_type_alpha2(global._part_type_18, 1,0);
part_type_shape(global._part_type_18, pt_shape_ring);

/* Type 19 - Thunder Bolt Particles 1 */
global._part_type_19 = part_type_create();
part_type_speed(global._part_type_19, 0.5, 1.5, -0.02, 0);
part_type_direction(global._part_type_19, 0, 180, 0, 1);
part_type_orientation(global._part_type_19, 0, 360, 1, 10, 0);
part_type_size(global._part_type_19, 0.20, 0.50, -0.02, 0);
part_type_scale(global._part_type_19, 0.16, 0.12);
part_type_life(global._part_type_19, 1 * _fps, 2 * _fps);
part_type_blend(global._part_type_19, true);
part_type_color3(global._part_type_19, $fff10c, $f9cd00, $dc9800);
part_type_alpha2(global._part_type_19, 1,0);
part_type_shape(global._part_type_19, pt_shape_square);


#endregion


function change_player_superstate(state) {
	switch (state) {
		case PLAYER_SUPERSTATES.inCombat: { // Combat Mode
			superstate_machine_set_state(superstateMachine, playerSuperstate[PLAYER_SUPERSTATES.inCombat]);
			superstate_clear_all_state_machines(playerSuperstate[PLAYER_SUPERSTATES.inCombat]);
			state_machine_start_state(superstateMachine, "movement", "walking");
			xForCameraOffset = global.windowW / 3;	
		break; }
		
		case PLAYER_SUPERSTATES.inTown: { // Town Mode
			superstate_machine_set_state(superstateMachine, playerSuperstate[PLAYER_SUPERSTATES.inTown]);
			superstate_clear_all_state_machines(playerSuperstate[PLAYER_SUPERSTATES.inTown]);
			state_machine_start_state(superstateMachine, "movement", "walking");
			xForCameraOffset = 0;
		break; }
	}
}