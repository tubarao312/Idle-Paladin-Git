// Smoke
particle1 = part_type_create();
part_type_speed(particle1, 0.15, 0.25, 0, 0.025);
part_type_direction(particle1, 0, 130, 0, 5);
part_type_gravity(particle1, 0.003, 145);
part_type_orientation(particle1, 0, 360, 0, 0, true);
part_type_size(particle1, 1, 1.5, -0.01, 0.1);
part_type_scale(particle1, 0.1, 0.13);
part_type_life(particle1, 100, 120);
part_type_blend(particle1, false);
part_type_color_mix(particle1, $927365, $6e4c42);
part_type_alpha3(particle1, 0.7, 1, 0.3);
part_type_shape(particle1, pt_shape_disk);

particle2 = part_type_create();
part_type_speed(particle2, 0.15, 0.25, 0, 0.025);
part_type_direction(particle2, 0, 130, 0, 5);
part_type_gravity(particle2, 0.003, 145);
part_type_orientation(particle2, 0, 360, 0, 0, true);
part_type_size(particle2, 1, 1.5, -0.01, 0.1);
part_type_scale(particle2, 0.05, 0.08);
part_type_life(particle2, 100, 120);
part_type_blend(particle2, false);
part_type_color_mix(particle2, $927365, $6e4c42);
part_type_alpha3(particle2, 0.7, 1, 0.3);
part_type_shape(particle2, pt_shape_square);

// Fire Spark
particle3 = part_type_create();
part_type_speed(particle3, 0.15, 0.25, 0, 0.025);
part_type_direction(particle3, 0, 180, 0, 7);
part_type_gravity(particle3, 0.003, 90);
part_type_orientation(particle3, 0, 360, 0, 5, true);
part_type_size(particle3, 1, 1.5, -0.01, 0.1);
part_type_scale(particle3, 0.04, 0.07);
part_type_life(particle3, 75, 125);
part_type_blend(particle3, true);
part_type_color_mix(particle3, $50abed, $2b1e89);
part_type_alpha3(particle3, 0.7, 1, 0.3);
part_type_shape(particle3, pt_shape_square);

emitter1 = part_emitter_create(global.part_system_fire_smoke);
part_emitter_region(global.part_system_fire_smoke, particle1, x, x, y, y, ps_shape_ellipse, ps_distr_linear);
part_emitter_stream(global.part_system_fire_smoke, particle1, particle1, 0);

particleSpawnCount = 0;