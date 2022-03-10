x += xSpd;

image_alpha = lerp(image_alpha,1.1,0.1);
image_xscale = lerp(image_xscale,1,0.2);
image_yscale = lerp(image_yscale,1,0.2);

switch alarm[1] { // Dash Circle Particles
	case 100: {
		var o = instance_create_layer(x+10,y-2,"Particles",oDashParticles);
		o.sprite_index = sRedDashParticle;
		o.image_speed = 1.5;
		o.image_yscale = 0.8;
	break; }
	
	case 95: {
		var o = instance_create_layer(x+10,y-1,"Particles",oDashParticles);
		o.sprite_index = sRedDashParticle;
		o.image_speed = 1.5;
		o.image_yscale = 0.7;
	break; }
	
	case 90: {
		var o = instance_create_layer(x+10,y,"Particles",oDashParticles);
		o.sprite_index = sRedDashParticle;
		o.image_speed = 1.5;
		o.image_yscale = 0.6;
	break; }
	
}


part_emitter_region(global.part_system_normal, emitter, x, x, y-3, y+3, ps_shape_ellipse, ps_distr_linear);
part_emitter_region(global.part_system_normal_b, emitter_b, x - 6, x - 2, y-6, y+6, ps_shape_ellipse, ps_distr_linear);
part_emitter_burst(global.part_system_normal, emitter, particle3, particleCount);
part_emitter_burst(global.part_system_normal, emitter, particle1, particleCount);

if chance(particleCount/17) {
	if chance(0.5) part_emitter_burst(global.part_system_normal_b, emitter_b, particleSmoke1, 1);
	else part_emitter_burst(global.part_system_normal_b, emitter_b, particleSmoke2, 1);
}

particleCount = lerp(particleCount, 6 , 0.1);

if instance_exists(hitbox) {
	hitbox.x = x-14;
	hitbox.y = y-23;
}

if (x > oPlayer.x+global.windowW+20) then instance_destroy();