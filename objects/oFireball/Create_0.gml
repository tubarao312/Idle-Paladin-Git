xSpd = 6.5;
alarm[2] = 0;

image_index = random_range(0,4);
image_speed = random_range(0.9,1.1);

screenshake(3,3);
screenfreeze(50);
shockwave(x,y,50,1,spr_shockwave_distortion_normals_256,2);

whiteAlpha = 0.6;

image_alpha = 0;
image_xscale = 0;
image_yscale = 2;

shadowFrequency = 7;
alarm[0] = 15;

alarm[1] = 120;

particleCount = 0;

part_emitter_region(global._part_system, global._part_emitter_1, x+50,x+60,y-10,y+10, ps_shape_ellipse, ps_distr_linear)
part_emitter_burst(global._part_system,global._part_emitter_1,global._part_type_1,100)
part_emitter_burst(global._part_system,global._part_emitter_1,global._part_type_18,25)

hitbox = create_hitbox(x-14,y-23,45,50,oEnemyParent,120, [true,HIT_TYPE_MAGIC,1.75*playerStats.baseDamage*playerStats.spellDamage]);