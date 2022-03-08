particle1 = part_type_create();
part_type_speed(particle1, 0.15, 0.25, 0, 0.025);
part_type_direction(particle1, 0, 180, 0, 7);
part_type_gravity(particle1, 0.003, 90);
part_type_orientation(particle1, 0, 360, 0, 5, true);
part_type_size(particle1, 1, 1.5, -0.01, 0.1);
part_type_scale(particle1, 0.04, 0.1);
part_type_life(particle1, 100, 150);
part_type_blend(particle1, true);
part_type_color_mix(particle1, $50abed, $2b1e89);
part_type_alpha3(particle1, 0.7, 1, 0.3);
part_type_shape(particle1, pt_shape_square);

emitter1 = part_emitter_create(global.part_system_lava);
part_emitter_region(global.part_system_lava, particle1, x, x, y, y, ps_shape_ellipse, ps_distr_linear);
part_emitter_stream(global.part_system_lava, particle1, particle1, 0);

particleSpawnCount = 0;