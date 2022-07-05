/// @description Heartbeat

if percentageHP < 0.75 {
	image_xscale = 1.75 - percentageHP + random_range(0,0.2);
	image_yscale = 1.75 - percentageHP + random_range(0,0.2);

	part_emitter_region(global.part_system_HUDAdd, emitter1, x, x, y, y, ps_shape_ellipse, ps_distr_linear);
	part_emitter_burst(global.part_system_HUDAdd, emitter1, particle2, (1 - percentageHP) * 10);

	// Partitions Positions
	partitionsHeight += 1;
	partitionsPosition += 3;
}

alarm[1] = max(90 - (1 - percentageHP) * 73, 1);