function add_player_mana(mana){
	currentPlayerStats.mana += mana;
	
	mana = abs(mana);
	mana = clamp(mana, 0.2, 0.75)
	
	var bar = oHUDManaBar;
	
	// Changing bar to orange color
	bar.sprite_index = sHUDManaBarBallGlowing;
	bar.manaPartitionSprite = sHUDManaBarFullGlowing;
	
	// Starting bar shake
	if mana < 0 {
		bar.xRel = random_sign() * mana * 6;
		bar.yRel = random_sign() * mana * 6;
	}
	
	bar.image_xscale = 1 + random_range(0.5, 1) * mana * 0.35;
	bar.image_yscale = 1 + random_range(0.5, 1) * mana * 0.35;
	
	bar.barShakeX = random_sign() * mana * 2.5;
	bar.barShakeY = random_sign() * mana * 2.5;
	
	bar.heartShakeX = random_sign() * mana * 2.5;
	bar.heartShakeY = random_sign() * mana * 2.5;
	
	bar.textShakeX = random_sign() * mana * 2.5;
	bar.textShakeY = random_sign() * mana * 2.5;
	
	// Changing Font
	bar.font = global.fontHopeManaGlowing;
	bar.textSprite = sHUDManaBarTextGlowing;
	
	// Emitting Particles
	part_emitter_region(global.part_system_HUDAdd, bar.emitter1, bar.x + 8 - 8, bar.x - 8 - 8, bar.y + 8 + 8, bar.y - 8 + 8, ps_shape_ellipse, ps_distr_linear);
	part_emitter_burst(global.part_system_HUDAdd, bar.emitter1, bar.particle2, mana * 35);
	part_emitter_burst(global.part_system_HUDAdd, bar.emitter1, bar.particle1, mana * 45);
	
	// Start countdown back to normal
	bar.alarm[0] = mana * 20;
	bar.image_speed = 0;
	
	// Partitions Positions
	bar.partitionsHeight += 4.5 * mana;
	bar.partitionsPosition += 20 * mana;
}