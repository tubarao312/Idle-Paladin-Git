function part_draw_hud_normal(){
	// Additive Surface
	if !surface_exists(global.surfParticlesHUD) then global.surfParticlesHUD = surface_create(global.windowW, global.windowH);

	surface_set_target(global.surfParticlesHUD);
		draw_clear_alpha(c_white, 0);
	
		part_system_drawit(global.part_system_HUD);
	
	surface_reset_target();
	
	draw_surface(global.surfParticlesHUD, 0, 0);
}