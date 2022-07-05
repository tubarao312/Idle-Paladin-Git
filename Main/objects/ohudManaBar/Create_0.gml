event_inherited()

// The small rectangles that make the Mana bar
partitionsHeight = 3;
partitionsPosition = 0;
manaPartitionSprite = sHUDManaBarFull;

// Currently used font, changes between blue and light blue
font = global.fontHopeMana;
textSprite = sHUDManaBarText;

// Individual Parts Shaking
ballShakeX = 0;
ballShakeY = 0;

barShakeX = 0;
barShakeY = 0;

textShakeX = 0;
textShakeY = 0;

// Leaving and Entering screen
originalX = xCreate;
originalY = yCreate;
xSpd = 0;
ySpd = 0;

// Heartbeat Alarm
alarm[1] = 20;

#region Particles

// Mana Particles
particle1 = part_type_create();
part_type_speed(particle1, 0.5, 1.5, -0.02, 0);
part_type_direction(particle1, 180, 180, 0, 1);
part_type_orientation(particle1, 0, 360, 1, 10, 0);
part_type_size(particle1, 0.20, 0.80, -0.02, 0);
part_type_scale(particle1, 0.16, 0.12);
part_type_life(particle1, 1 * 60, 2 * 60);
part_type_blend(particle1, false);
part_type_color3(particle1, $fff10c, $f9cd00, $dc9800);
part_type_alpha2(particle1, 1,0);
part_type_shape(particle1, pt_shape_square);

// Mana Particle Bubbles
particle2 = part_type_create();
part_type_speed(particle2, 0.5, 1.5, -0.02, 0);
part_type_direction(particle2, 180, 180, 1, 3);
part_type_orientation(particle2, 0, 360, 1, 10, 0);
part_type_size(particle2, 0.20, 1.20, -0.02, 0);
part_type_scale(particle2, 0.16, 0.12);
part_type_life(particle2, 1 * 60, 2 * 60);
part_type_blend(particle2, false);
part_type_color3(particle2, $fff10c, $f9cd00, $dc9800);
part_type_alpha2(particle2, 1,0);
part_type_shape(particle2, pt_shape_ring);

emitter1 = part_emitter_create(global.part_system_HUDAdd);
part_emitter_region(global.part_system_HUD, particle1, x, x, y, y, ps_shape_ellipse, ps_distr_linear);
part_emitter_stream(global.part_system_HUD, particle1, particle1, 0);

#endregion