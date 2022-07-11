xSpd = 6.5;
alarm[2] = 0;

image_index = random_range(0,4);
image_speed = random_range(0.9,1.1);

// Impact Effects
screenshake(3,3);
screenfreeze(50);
shockwave(x, bbox_bottom, 45, 2, spr_shockwave_distortion_normals_256, random_range(1.1,1.4));

whiteAlpha = 0.6;

image_alpha = 0;
image_xscale = 0;
image_yscale = 2;

shadowFrequency = 7;
alarm[0] = 15;
alarm[1] = 120;

particleCount = 0;

// Particles
emitter = part_emitter_create(global.part_system_normal);
emitter_b = part_emitter_create(global.part_system_normal_b); // Drawn first

particle1 = part_type_create(); {
	part_type_speed(particle1, 2, 3, -0.2, 0);
	part_type_direction(particle1, 90, 270, 0, 0);
	part_type_gravity(particle1, 0.03, 270);
	part_type_orientation(particle1, 0, 360, 2, 5, 0);
	part_type_size(particle1, 0.10, 0.40, -0.02, 0.2);
	part_type_scale(particle1, 0.1, 0.1);
	part_type_life(particle1, 0.3 * 60, 0.6 * 60);
	part_type_blend(particle1, true);
	part_type_color_mix(particle1, $25c8ff, $3024c4);
	part_type_alpha2(particle1, 1, 0);
	part_type_shape(particle1, pt_shape_square);
}
particle2 = part_type_create(); {
	part_type_speed(particle2, 0.5, 1.5, -0.02, 0);
	part_type_direction(particle2, 180, 180, 1, 3);
	part_type_orientation(particle2, 0, 360, 1, 10, 0);
	part_type_size(particle2, 0.20, 1.20, -0.02, 0);
	part_type_scale(particle2, 0.16, 0.12);
	part_type_life(particle2, 1 * 60, 2 * 60);
	part_type_blend(particle2, true);
	part_type_color_mix(particle2, $25c8ff, $3024c4);
	part_type_alpha2(particle2, 1,0);
	part_type_shape(particle2, pt_shape_ring);
}
particle3 = part_type_create(); {
	part_type_speed(particle3, 0.5, 1.5, -0.02, 0);
	part_type_direction(particle3, 180, 180, 0, 1);
	part_type_orientation(particle3, 0, 360, 1, 10, 0);
	part_type_size(particle3, 0.20, 0.80, -0.02, 0);
	part_type_scale(particle3, 0.16, 0.12);
	part_type_life(particle3, 1 * 60, 1.5 * 60);
	part_type_blend(particle3, true);
	part_type_color_mix(particle3, $25c8ff, $3024c4);
	part_type_alpha2(particle3, 1,0);
	part_type_shape(particle3, pt_shape_square);
}

particleSpark = part_type_create(); {
	part_type_speed(particleSpark, 0.45, 0.60, -0.001, 0.025);
	part_type_direction(particleSpark, 0, 180, 0, 7);
	part_type_gravity(particleSpark, 0.002, -90);
	part_type_orientation(particleSpark, 0, 360, 0, 5, true);
	part_type_size(particleSpark, 1, 1.50, -0.02, 0.2);
	part_type_scale(particleSpark, 0.04, 0.07);
	part_type_life(particleSpark, 45, 90);
	part_type_blend(particleSpark, true);
	part_type_color_mix(particleSpark, $50abed, $2b1e89);
	part_type_alpha3(particleSpark, 0.7, 1, 0.3);
	part_type_shape(particleSpark, pt_shape_square);
}

particleSmoke1 = part_type_create(); {
	part_type_speed(particleSmoke1, 0.15, 0.25, 0, 0.03);
	part_type_direction(particleSmoke1, 0, 130, 0, 5);
	part_type_gravity(particleSmoke1, 0.003, 145);
	part_type_orientation(particleSmoke1, 0, 360, 0, 0, true);
	part_type_size(particleSmoke1, 1, 1.5, -0.01, 0.1);
	part_type_scale(particleSmoke1, 0.1, 0.13);
	part_type_life(particleSmoke1, 100, 120);
	part_type_blend(particleSmoke1, false);
	part_type_color_mix(particleSmoke1, $927365, $6e4c42);
	part_type_alpha3(particleSmoke1, 0.7, 1, 0.3);
	part_type_shape(particleSmoke1, pt_shape_disk);
}
particleSmoke2 = part_type_create(); {
	part_type_speed(particleSmoke2, 0.15, 0.25, 0, 0.03);
	part_type_direction(particleSmoke2, 0, 130, 0, 5);
	part_type_gravity(particleSmoke2, 0.003, 145);
	part_type_orientation(particleSmoke2, 0, 360, 0, 0, true);
	part_type_size(particleSmoke2, 1, 1.5, -0.01, 0.1);
	part_type_scale(particleSmoke2, 0.05, 0.08);
	part_type_life(particleSmoke2, 100, 120);
	part_type_blend(particleSmoke2, false);
	part_type_color_mix(particleSmoke2, $927365, $6e4c42);
	part_type_alpha3(particleSmoke2, 0.7, 1, 0.3);
	part_type_shape(particleSmoke2, pt_shape_square);
}

part_emitter_region(global.part_system_normal, emitter, x+50,x+60,y-10,y+10, ps_shape_ellipse, ps_distr_linear);
part_emitter_burst(global.part_system_normal, emitter, particle1, 100);
part_emitter_burst(global.part_system_normal, emitter, particle2, 25);

// Hit Effects

fireballHit = {};
fireballHit.vars = {
	damage: 30,
	emitter: part_emitter_create(global.part_system_normal),
	emitter_b: part_emitter_create(global.part_system_normal_b),
	particle1: particle1,
	particle2: particle2,
	particle3: particle3,
	particleSpark: particleSpark,
	particleSmoke1: particleSmoke1,
	particleSmoke2: particleSmoke2,
};

fireballHit.vars.attacker = oPlayer;

fireballHit.apply_effects = function(vars, entityHit) { // The function that runs when the enemy is hit
	vars.entityHit = entityHit;
	
	with entityHit var func = function(vars) {
		// Calculating FX Intensity
		var hitImpact = min(max(vars.damage/get_max_hp(), 0.95), 1.2);
		
		// Applying Damage
		get_damaged(vars.damage * random_range(0.9,1.1));
		
		// Creating Floating Text
		floating_text(x, y, vars.damage + round(random_range(0,10)), global.fontHopeLegendary);
	
		// HP Bar Stuff
		alarm[3] = 3; // Resetting Speed for Yellow Part of HP Bar
		visuals.hpBarShake = hitImpact * 4; // Making the HP Bar shake
	
		// Impact Effects
		screenshake(4 * hitImpact, 3);
		screenfreeze(40 * hitImpact);
		shockwave(x, y, 45, 1, spr_shockwave_distortion_normals_256, random_range(1.1,1.4));
	
		// White Alpha Effect
		col_sprite_set_blendmode(visuals.colConfig, bm_add);
		col_sprite_set_alpha(visuals.colConfig, 1.2);
		col_sprite_set_col(visuals.colConfig, $3874e0);
		
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
		// add_player_mana(min(vars.damage/get_max_hp(), 1) * 1.25);
		
		// Visual Effects
		var o = instance_create_depth(x+random_range(-1,1), y+random_range(-1,1), depth-1, oHitEffect1)
		o.sprite_index = sHitEffectFire1;
		o.xscale1 = random_range(0.7,1.2) * hitImpact * get_effects_size();
		o.yscale1 = random_range(0.7,1.2) * hitImpact * get_effects_size();
		o.xscale2 = random_range(0.7,1.2) * hitImpact * get_effects_size();
		o.yscale2 = random_range(0.7,1.2) * hitImpact * get_effects_size();
		
		var o = instance_create_depth(x+random_range(-1,1), y+random_range(-1,1), depth-1 ,oHitEffect2)
		o.sprite_index = sHitLineFire;
		o.image_xscale = 0.45 * hitImpact * get_effects_size();
		o.image_yscale = 0.50 * hitImpact * get_effects_size();
		
		var o = instance_create_depth(x+random_range(-1,1), y+random_range(-1,1), depth-1 ,oHitEffect2)
		o.sprite_index = sHitLineFire;
		o.image_xscale = 0.30 * hitImpact * get_effects_size();
		o.image_yscale = 0.65 * hitImpact * get_effects_size();
		
		// Particles
		part_emitter_region(global.part_system_normal, vars.emitter, x-5, x+5, y-5, y+5, ps_shape_ellipse, ps_distr_linear);
		part_emitter_burst(global.part_system_normal, vars.emitter, vars.particle1, 1.5 * min(80,80*(vars.damage / get_max_hp())) * get_effects_size());
		part_emitter_burst(global.part_system_normal, vars.emitter, vars.particle3, 1.5 * min(20,20*(vars.damage / get_max_hp())) * get_effects_size());

		part_emitter_region(global.part_system_normal, vars.emitter, x+12, x-12, y+12, y-12, ps_shape_ellipse, ps_distr_linear);
		part_emitter_burst(global.part_system_normal, vars.emitter, vars.particle2, 30);
		part_emitter_burst(global.part_system_normal, vars.emitter, vars.particleSpark, 20);
		
		part_emitter_region(global.part_system_normal_b, vars.emitter_b, x-5, x+5, y-5, y+5, ps_shape_ellipse, ps_distr_linear);
		part_emitter_burst(global.part_system_normal_b, vars.emitter_b, vars.particleSmoke1, 0.15 * min(80,80*(vars.damage / get_max_hp())) * get_effects_size());
		part_emitter_burst(global.part_system_normal_b, vars.emitter_b, vars.particleSmoke2, 0.15 * min(20,20*(vars.damage / get_max_hp())) * get_effects_size());
		
	}
	
	delay_function(entityHit, func, vars, 3);
}

hitbox = create_hitbox(x-14,y-23, 45,50, oEnemyParent, 120, fireballHit);