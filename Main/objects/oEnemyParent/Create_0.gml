#region Components

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
	grav: 0.625,
	
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
	
	var h,v // Round Numbers so that when hsp = 0.4 the player doesn't actually move but precision is kept
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
			
			} else {
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
			
			} else {
				v = 0;
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
	
	// Sprite Shaking
	xShake: 0,
	yShake: 0,
	xScaleShake: 0,
	yScaleShake: 0,
	
	// HP Bar
	hpBarShake: 0,
	hpBarYellowPercentage: 100,
	hpBarYellowSpd: 0,
}

function visual_component(visuals) { // Processing the visuals (done in the draw event)
	// Enemy Shadow
	if physics.onGround and (spr.shadow != noone) then draw_sprite_ext(spr.shadow, 0, x + spr.shadowRelX, y + spr.shadowRelY, 1, 1, 0, c_white, 0.4);
	
	#region Storing Variables and changing them temporarily
	var temp = {};
	temp.x = x;
	temp.y = y;
	temp.image_xscale = image_xscale;
	temp.image_yscale = image_yscale;
	
	x = x + visuals.xShake;
	y = y + visuals.yShake;
	image_xscale = image_xscale + visuals.xScaleShake;
	image_yscale = image_yscale + visuals.yScaleShake;
	#endregion
	
	// Enemy Sprite
	draw_self();
	
	// White Alpha Effect
	col_sprite_add_alpha(visuals.colConfig, -0.05);
	col_sprite_draw_obj(visuals.colConfig, self);
	
	#region Loading variables back
	x = temp.x;
	y = temp.y;
	image_xscale = temp.image_xscale;
	image_yscale = temp.image_yscale;
	#endregion
	
	// Sprite Shaking
	visuals.xShake = -lerp(visuals.xShake, 0, 0.1);
	visuals.yShake = -lerp(visuals.yShake, 0, 0.1);
	visuals.xScaleShake = -lerp(visuals.xScaleShake, 0, 0.1);
	visuals.yScaleShake = -lerp(visuals.yScaleShake, 0, 0.1);
	
	#region Health Bar
	
	// Calculating Current HP Percentage
	var hpPercentage = enemyStats.hp / enemyStats.maxHP * 100;
	
	visuals.hpBarShake = lerp(visuals.hpBarShake, 0, 0.1);
	
	if hpPercentage < 99 && hpPercentage > 0 { // Only draw the HP bar when relevant
		//Calculating Yellow Part Values
		if alarm[3] <= 0 then visuals.hpBarYellowSpd += 0.03;
		else visuals.hpBarYellowSpd = 0;
	
		visuals.hpBarYellowPercentage = max(visuals.hpBarYellowPercentage - visuals.hpBarYellowSpd, hpPercentage);
		
		// Drawing the actual HP Bar
		var hpBarX = x + enemyStats.hpBarRelX + random_range(-visuals.hpBarShake, visuals.hpBarShake);
		var hpBarY = y + enemyStats.hpBarRelY + random_range(-visuals.hpBarShake, visuals.hpBarShake);
		
		draw_hpbar(hpBarX, hpBarY, enemyStats.hpBarType, hpPercentage, visuals.hpBarYellowPercentage);
		
		// Drawing a white flash for the HP Bar
		gpu_set_blendmode(bm_add);
		gpu_set_fog(true, visuals.colConfig.col, 0, 1);
		draw_set_alpha(round(visuals.colConfig.alpha*6)/6 /4);
		draw_hpbar(hpBarX, hpBarY, enemyStats.hpBarType, hpPercentage, visuals.hpBarYellowPercentage);
		draw_set_alpha(1);
		gpu_set_fog(false, c_white, 0, 1);
		gpu_set_blendmode(bm_normal);
		
	}
		
	#endregion
}

sounds = {} // Sound Related Attributes

function sound_component(sounds) {} // Processing the sounds

function update_step() { // Stuff that can be done in the step event
	physics_component(physics);
	sound_component(sounds);
}

function update_draw() { // Stuff that needs to be done in the draw event
	visual_component(visuals);
}

#endregion

#region Superstate Machine

superstateMachine = superstate_machine_create();

#endregion

// Collision Tilemaps
tilemap = layer_tilemap_get_id("Collision");
stopPointsTilemap = layer_tilemap_get_id("EnemyStopPoints");

// Reading Hits
create_hits_taken_list();

#region Functions to utilize in hit reading

// Taking Damage
function get_damaged(damage) {
	enemyStats.hp -= damage;
}

// Return Max Health
function get_max_hp() {
	return enemyStats.maxHP;
}

// Return Current Health
function get_hp() {
	return enemyStats.hp;
}


// Return VFX Size for getting hit
function get_effects_size() {
	return enemyStats.effectsSize;
}
#endregion