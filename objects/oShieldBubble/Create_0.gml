// Shake
shakeX = 0;
shakeY = 0;
shake = 0;

// Stretch
stretchX = 0.5;
stretchY = 0.5;

stretchTimerX = 0;
stretchTimerY = 0;

alarm[0] = 1;

// Transparency
alphaShake = 0;
image_alpha = 0.4;

// VFX
shockwave(x, bbox_bottom, 45, 2, spr_shockwave_distortion_normals_256, random_range(1.1,1.4));
screenshake(2,3);

#region Particles
	particles1 = part_type_create(); // Sprinkles
	part_type_speed(particles1, 2, 3, -0.2, 0);
	part_type_direction(particles1, 90, 270, 0, 0);
	part_type_gravity(particles1, 0.03, 270);
	part_type_orientation(particles1, 0, 360, 2, 5, 0);
	part_type_size(particles1, 0.10, 0.40, -0.02, 0.2);
	part_type_scale(particles1, 0.1, 0.1);
	part_type_life(particles1, 0.3 * 60, 0.6 * 60);
	part_type_blend(particles1, true);
	part_type_color_mix(particles1, $5fe699, $4b9833);
	part_type_alpha2(particles1, 1, 0);
	part_type_shape(particles1, pt_shape_square);

	particles2 = part_type_create(); // Bubbles
	part_type_speed(particles2, 0.5, 1.5, -0.02, 0);
	part_type_direction(particles2, 180, 180, 1, 3);
	part_type_orientation(particles2, 0, 360, 1, 10, 0);
	part_type_size(particles2, 0.20, 1.20, -0.02, 0);
	part_type_scale(particles2, 0.16, 0.12);
	part_type_life(particles2, 1 * 60, 2 * 60);
	part_type_blend(particles2, true);
	part_type_color_mix(particles2, $5fe699, $4b9833);
	part_type_alpha2(particles2, 1,0);
	part_type_shape(particles2, pt_shape_ring);

	particles3 = part_type_create(); // Sprinkles
	part_type_speed(particles3, 4, 5, -0.3, 0.3);
	part_type_direction(particles3, 90, 270, 5, 10);
	part_type_gravity(particles3, 0.05, 90);
	part_type_orientation(particles3, 0, 360, 10, 20, 0);
	part_type_size(particles3, 0.10, 0.40, -0.001, 0.1);
	part_type_scale(particles3, 0.1, 0.1);
	part_type_life(particles3, 1.5 * 60, 1.75 * 60);
	part_type_blend(particles3, true);
	part_type_color_mix(particles3, $5fe699, $4b9833);
	part_type_alpha2(particles3, 1, 0);
	part_type_shape(particles3, pt_shape_square);
	
	emitter = part_emitter_create(global.part_system_normal);
	
#endregion

// Start Particles
passiveParticleCount = 7;

function shake_bubble() {
	shake = random_range(3, 5);
	
	stretchX = random_range(0.6, 0.8);
	stretchY = random_range(-0.45, -0.25);
	
	alphaShake = random_range(0.3, 0.4);
	
	passiveParticleCount = random_range(4, 5);
	shockwave(x, bbox_bottom, 45, 1, spr_shockwave_distortion_normals_256, random_range(1.1,1.4));
}