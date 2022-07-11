function part_draw_hud_add(){
	// Additive Surface
	if !surface_exists(global.surfParticlesHUDAdd) then global.surfParticlesHUDAdd = surface_create(global.windowW, global.windowH);

	surface_set_target(global.surfParticlesHUDAdd);
		draw_clear_alpha(c_white, 0);
	
		if global.enableHUD then part_system_drawit(global.part_system_HUDAdd);
		
	surface_reset_target();

	gpu_set_blendmode(bm_add);
	draw_surface(global.surfParticlesHUDAdd, 0, 0);
	gpu_set_blendmode(bm_normal);
}