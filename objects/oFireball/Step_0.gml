x += xSpd;

image_alpha = lerp(image_alpha,1.1,0.1);
image_xscale = lerp(image_xscale,1,0.2);
image_yscale = lerp(image_yscale,1,0.2);


switch alarm[1] {
	case 100: {
		var o = instance_create_layer(x+10,y-2,"Particles",oDashParticles);
		o.image_speed = 1.5;
		o.image_yscale = 0.8;
	break; }
	case 95: {
		var o = instance_create_layer(x+10,y-1,"Particles",oDashParticles);
		o.image_speed = 1.5;
		o.image_yscale = 0.7;
	break; }
	case 90: {
		var o = instance_create_layer(x+10,y,"Particles",oDashParticles);
		o.image_speed = 1.5;
		o.image_yscale = 0.6;
	break; }
	
}


part_emitter_region(global._part_system, global._part_emitter_1, x,x,y-3,y+3, ps_shape_ellipse, ps_distr_linear)
part_emitter_burst(global._part_system,global._part_emitter_1,global._part_type_17,particleCount)
part_emitter_burst(global._part_system,global._part_emitter_1,global._part_type_1,particleCount)

particleCount = lerp(particleCount,6,0.1);

if instance_exists(hitbox) {
	hitbox.x = x-14;
	hitbox.y = y-23;
}

if (x > oPlayer.x+global.windowW+20) then instance_destroy();