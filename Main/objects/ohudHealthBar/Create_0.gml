event_inherited();

percentageHP = 1;

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
