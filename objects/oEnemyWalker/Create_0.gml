

// Inherit the parent event
event_inherited();

#region Superstate Machine

enemySuperstate = superstate_create();

// State machine for running, jumping, etc...
var movementStateMachine = state_machine_create("movement");
superstate_add_state_machine(enemySuperstate, movementStateMachine);

#region Standing

var state, stateFunc;

stateFunc[STATES.start] = function() { // Start Standing 
	// Phyiscs Setup
	physics.maxvsp = 5;
	physics.minvsp = -20;
	physics.minhsp = -enemyStats.walkSpd;
	physics.maxhsp = enemyStats.walkSpd;
	
	// Animations
	image_index = 0;
	sprite_index = spr.standing;
	image_speed = 1;
} 

stateFunc[STATES.step] = function() { // Step Standing
	// Physics
	physics.hsp = lerp(physics.hsp, 0, 0.1);
	physics.vacc = physics.grav;
	
	// Animations
	image_yscale = 1;
	image_xscale = 1 * physics.dir;
	image_speed = 1;
	sprite_index = spr.standing;
	
	// State Transitions
	if enemyStats.hp <= 0 { // Dying
		state_machine_queue_state(superstateMachine, "movement", "dying");
		state_machine_end_state(superstateMachine, "movement");
	}
	else if (abs(enemyStats.enemy.x - x) <= enemyStats.walkRange // Walking
	  and !tilemap_get_at_pixel(stopPointsTilemap, bbox_left-1, bbox_bottom)
	  and !tilemap_get_at_pixel(stopPointsTilemap, bbox_left-1, bbox_top)) 
	  and !tilemap_get_at_pixel(tilemap, bbox_left-1, bbox_bottom)
	  and !tilemap_get_at_pixel(tilemap, bbox_left-1, bbox_top) {
		state_machine_start_state(superstateMachine, "movement", "walking");
	}
	else if enemyStats.canAttack and (abs(enemyStats.enemy.x - x) <= enemyStats.attackRange) and (enemyStats.enemy.x < x) { // Attacking
		state_machine_start_state(superstateMachine, "movement", "attacking");
	}

}

stateFunc[STATES.finish] = function() {} // Finish Standing

state = state_create("standing", stateFunc[STATES.start], stateFunc[STATES.step], stateFunc[STATES.finish]);
state_machine_add_state(movementStateMachine, state);

#endregion

#region Walking

var state, stateFunc;

stateFunc[STATES.start] = function() { // Start Walking 
	
	// Animations
	image_index = 0;
	sprite_index = spr.walking;
	image_speed = 1;
} 

stateFunc[STATES.step] = function() { // Step Walking
	// Physics
	physics.hsp = lerp(physics.hsp, -enemyStats.walkSpd * physics.dir, 0.1);
	physics.vacc = physics.grav;
	
	// Animations
	image_yscale = 1;
	image_xscale = 1 * physics.dir;
	image_speed = abs(physics.hsp / enemyStats.walkSpd);
	sprite_index = spr.walking;
	
	// State Transitions
	if enemyStats.hp <= 0 { // Dying
		state_machine_queue_state(superstateMachine, "movement", "dying");
		state_machine_end_state(superstateMachine, "movement");
	}
	else if enemyStats.canAttack and (abs(enemyStats.enemy.x - x) <= enemyStats.attackRange) and (enemyStats.enemy.x < x) { // Attacking
		state_machine_start_state(superstateMachine, "movement", "attacking");
	}
	else if (abs(enemyStats.enemy.x - x) > enemyStats.walkRange) // Standing
	  or tilemap_get_at_pixel(stopPointsTilemap, bbox_left-1, bbox_bottom)
	  or tilemap_get_at_pixel(stopPointsTilemap, bbox_left-1, bbox_top)
	  or tilemap_get_at_pixel(tilemap, bbox_left-1, bbox_bottom)
	  or tilemap_get_at_pixel(tilemap, bbox_left-1, bbox_top) { 
		state_machine_end_state(superstateMachine, "movement");
		return;
	}
}

stateFunc[STATES.finish] = function() {} // Finish Walking

state = state_create("walking", stateFunc[STATES.start], stateFunc[STATES.step], stateFunc[STATES.finish]);
state_machine_add_state(movementStateMachine, state);

#endregion

#region Attacking

stateFunc[STATES.start] = function() { // Start Attacking
	// Hitbox Setup
	enemyStats.canSpawnHitbox = true;
	attackHitbox = noone;
	
	// Physics
	physics.hsp = 0;
	
	// Animations Setup
	sprite_index = spr.attacking;
	image_index = 0;
	image_speed = enemyStats.attackSpd;
	
	// Sync animation ending with state ending
	triggerFinishAnimation = false;
} 

stateFunc[STATES.step] = function() { // Step Attacking
	
	// Spawning Hitbox
	if enemyStats.canSpawnHitbox and !instance_exists(attackHitbox) and floor(image_index) >= enemyStats.hitboxActivateIndex {
		enemyStats.canSpawnHitbox = false;
		attackHitbox = create_hitbox( 
			x +	enemyStats.attackHitboxRelX,
			y + enemyStats.attackHitboxRelY,
			enemyStats.attackHitboxWidth,
			enemyStats.attackHitboxHeight,
			enemyStats.enemy,
			enemyStats.attackHitboxDuration / enemyStats.attackSpd, 
			meleeHit);
	
	}
	
	// Dragging Hitbox Around
	if instance_exists(attackHitbox) {
		attackHitbox.x = x + enemyStats.attackHitboxRelX;
		attackHitbox.y = y + enemyStats.attackHitboxRelY;
	}
	
	// Physics
	physics.vacc = physics.grav;
	physics.hsp = lerp(physics.hsp, 0, 0.1);
	
	// Animations
	image_xscale = 1;
	image_yscale = 1;
	
	// State Transitions
	if enemyStats.hp <= 0 { // Dying
		state_machine_queue_state(superstateMachine, "movement", "dying");
		state_machine_end_state(superstateMachine, "movement");
	} else if triggerFinishAnimation { // Leaving the attack state
		state_machine_end_state(superstateMachine, "movement");
	}
	
} 

stateFunc[STATES.finish] = function() { // Finish Attacking
	
	//Hitbox Cleanup
	if instance_exists(attackHitbox) then instance_destroy(attackHitbox);
} 

state = state_create("attacking", stateFunc[STATES.start], stateFunc[STATES.step], stateFunc[STATES.finish]);
state_machine_add_state(movementStateMachine, state);

#endregion

#region Dying

stateFunc[STATES.start] = function() { // Start Dying
	
	// Disabling Melee Hits
	enemyStats.canBeAttacked = false;
	
	// Physics Definitions
	physics.maxvsp = 5;
	physics.minvsp = -20;
	
	// Animations Setup
	sprite_index = spr.dying;
	image_index = 0;
	image_speed = random_range(0.9, 1.1);
	spr.shadow = noone;
	
	// Sync animation ending with state ending
	triggerFinishAnimation = false;
} 

stateFunc[STATES.step] = function() { // Step Dying
	
	// Physics
	physics.vacc = physics.grav;
	physics.hsp = lerp(physics.hsp, 0, 0.3);
	
	// Animations
	image_xscale = 1;
	image_yscale = 1;
	if triggerFinishAnimation { // Stopping the animation
		image_speed = 0;
		image_index = sprite_get_number(spr.dying) - 1;
	}
} 

stateFunc[STATES.finish] = function() { // Finish Dying
	
} 

state = state_create("dying", stateFunc[STATES.start], stateFunc[STATES.step], stateFunc[STATES.finish]);
state_machine_add_state(movementStateMachine, state);

#endregion

superstate_machine_set_state(superstateMachine, enemySuperstate);
state_machine_start_state(superstateMachine, "movement", "standing");


#endregion ----------------------------------------------------------------------------------------#


#region Generating Melee Hit

meleeHit = {};
meleeHit.vars = {
	damage: 1,
};
meleeHit.vars.attacker = self;

meleeHit.apply_effects = function(vars, entityHit) { // The function that runs when the enemy is hit
	// Getting Damaged
	entityHit.get_damaged(vars.damage);
	
	col_sprite_set_alpha(entityHit.visuals.colConfig, 1.1);
	col_sprite_set_col(entityHit.visuals.colConfig, c_white);
	col_sprite_set_blendmode(entityHit.visuals.colConfig, bm_add);
}
	
#endregion

