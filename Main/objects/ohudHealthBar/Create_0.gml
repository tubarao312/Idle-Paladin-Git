event_inherited();

percentageHP = playerStats.currentHP / playerStats.maxHP;

// The small rectangles that make the HP bar
HPPartitions = 13;
HPPartitionSprite = sHUDHPBarPartition;
partitionsHeight = 3;
partitionsPosition = 0;

// Currently used font, changes between orange and red
font = global.fontHopeHP;

// Individual Parts Shaking
heartShakeX = 0;
heartShakeY = 0;

barShakeX = 0;
barShakeY = 0;

textShakeX = 0;
textShakeY = 0;

// Heartbeat Alarm
alarm[1] = 20;

// Leaving and Entering screen
originalX = xCreate;
originalY = yCreate;
xSpd = 0;
ySpd = 0;


#region Particles 

particle1 = part_type_create();
part_type_speed(particle1, 2, 3, -0.2, 0);
part_type_direction(particle1, 0, 360, 0, 0);
part_type_gravity(particle1, 0.03, 270);
part_type_orientation(particle1, 0, 360, 2, 5, 0);
part_type_size(particle1, 0.20, 0.50, -0.02, 0.2);
part_type_scale(particle1, 0.1, 0.1);
part_type_life(particle1, 0.3 * 60, 0.6 * 60);
part_type_blend(particle1, false);
part_type_color_mix(particle1, $5d55f5, $cfe6f9);
part_type_alpha2(particle1, 1, 0);
part_type_shape(particle1, pt_shape_square);

particle2 = part_type_create();
part_type_speed(particle2, 2, 3, -0.2, 0);
part_type_direction(particle2, 130, 360, -8, 2);
part_type_gravity(particle2, 0.015, 90);
part_type_orientation(particle2, 0, 360, 2, 5, 0);
part_type_size(particle2, 0.70, 1.10, -0.02, 0.2);
part_type_scale(particle2, 0.1, 0.1);
part_type_life(particle2, 0.3 * 60, 0.6 * 60);
part_type_blend(particle2, false);
part_type_color_mix(particle2, $3024c4, $3024c4);
part_type_alpha2(particle2, 1, 0.3);
part_type_shape(particle2, pt_shape_ring);

emitter1 = part_emitter_create(global.part_system_HUDAdd);
part_emitter_region(global.part_system_HUD, particle1, x, x, y, y, ps_shape_ellipse, ps_distr_linear);
part_emitter_stream(global.part_system_HUD, particle1, particle1, 0);

#endregion

function add_hp(hp) { // Applies damage to the health bar.
	var damagePercentage = clamp(abs(hp/playerStats.maxHP), 0.15, 0.4);
	var fxIntensity = abs(playerStats.currentHP/playerStats.maxHP - (hp+playerStats.currentHP)/playerStats.maxHP) * 4;

	playerStats.currentHP += hp;
	
	// Changing bar to new color and applying juicy effects
	if hp < 0 {		
		sprite_index = sHUDHPBarHeartDamaged;
		HPPartitionSprite = sHUDHPBarPartitionDamaged;
	
		#region Juicy Effects

		screenshake(2*fxIntensity, 3*fxIntensity);
		screenfreeze(20*fxIntensity);
		
		#endregion
	} else {
		sprite_index = sHUDHPBarHeartHeal;
		HPPartitionSprite = sHUDHPBarPartitionHeal;
	}
	
	// Starting bar shake
	if hp < 0 {
		xRel = random_sign() * damagePercentage * 15;
		yRel = random_sign() * damagePercentage * 15;
	}
	
	image_xscale = 1 + random_range(0.5, 1) * damagePercentage * 3.5;
	image_yscale = 1 + random_range(0.5, 1) * damagePercentage * 3.5;
	
	barShakeX = random_sign() * damagePercentage * 7.5;
	barShakeY = random_sign() * damagePercentage * 7.5;
	
	heartShakeX = random_sign() * damagePercentage * 7.5;
	heartShakeY = random_sign() * damagePercentage * 7.5;
	
	textShakeX = random_sign() * damagePercentage * 7.5;
	textShakeY = random_sign() * damagePercentage * 7.5;
	
	// Changing Font
	if hp < 0 then font = global.fontHopeHPDamaged;
	else font = global.fontHopeHPHeal;
	
	// Emitting Particles
	part_emitter_region(global.part_system_HUDAdd, emitter1, x, x, y, y, ps_shape_ellipse, ps_distr_linear);
	part_emitter_burst(global.part_system_HUDAdd, emitter1, particle2, damagePercentage * 20);
	part_emitter_burst(global.part_system_HUDAdd, emitter1, particle1, damagePercentage * 200);
	
	// Start countdown back to normal
	alarm[0] = damagePercentage * 70;
	alarm[1] = 1;
	image_speed = 0;
	
	// Partitions Positions
	partitionsHeight += 7 * damagePercentage;
	partitionsPosition += 20 * damagePercentage;
}