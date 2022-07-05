/// @description Death Particles

shockwave(x,y,30,30,spr_shockwave_distortion_normals_256,3);
part_emitter_region(global._part_system, global._part_emitter_3, x,x,y,y, ps_shape_ellipse, ps_distr_linear);
part_emitter_burst(global._part_system,global._part_emitter_3,global._part_type_15,5);
part_emitter_region(global._part_system, global._part_emitter_3, x,x,y,y, ps_shape_ellipse, ps_distr_linear);
part_emitter_burst(global._part_system,global._part_emitter_3,global._part_type_16,500);


screenshake(3, 3);
screenfreeze(30);

var o = instance_create_depth(x + random_range(-1, 1), y + random_range(-1, 1), depth - 1, oHitEffect2);
o.image_xscale = 0.45;
o.image_yscale = 0.5;

var o = instance_create_depth(x + random_range(-1, 1), y + random_range(-1, 1), depth - 1, oHitEffect2);
o.image_xscale = 0.6;
o.image_yscale = 0.7;