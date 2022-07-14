function add_player_hp(hp){
	var bar = oHUDHealthBar;
	var damagePercentage = clamp(abs(hp/playerStats.maxHP), 0.15, 0.4);
	var fxIntensity = abs(currentPlayerStats.hp/playerStats.maxHP - (hp+currentPlayerStats.hp)/playerStats.maxHP) * 4;

	currentPlayerStats.hp += hp;
	
	// Changing bar to new color and applying juicy effects
	if hp < 0 {		
		bar.sprite_index = sHUDHPBarHeartDamaged;
		bar.HPPartitionSprite = sHUDHPBarPartitionDamaged;
	
		#region Juicy Effects

		screenshake(2*fxIntensity, 3*fxIntensity);
		screenfreeze(20*fxIntensity);
		
		#endregion
	} else {
		bar.sprite_index = sHUDHPBarHeartHeal;
		bar.HPPartitionSprite = sHUDHPBarPartitionHeal;
	}
	
	// Starting bar shake
	if hp < 0 {
		bar.xRel = random_sign() * damagePercentage * 15;
		bar.yRel = random_sign() * damagePercentage * 15;
	}
	
	bar.image_xscale = 1 + random_range(0.5, 1) * damagePercentage * 3.5;
	bar.image_yscale = 1 + random_range(0.5, 1) * damagePercentage * 3.5;
	
	bar.barShakeX = random_sign() * damagePercentage * 7.5;
	bar.barShakeY = random_sign() * damagePercentage * 7.5;
	
	bar.heartShakeX = random_sign() * damagePercentage * 7.5;
	bar.heartShakeY = random_sign() * damagePercentage * 7.5;
	
	bar.textShakeX = random_sign() * damagePercentage * 7.5;
	bar.textShakeY = random_sign() * damagePercentage * 7.5;
	
	// Changing Font
	if hp < 0 then bar.font = global.fontHopeHPDamaged;
	else bar.font = global.fontHopeHPHeal;
	
	// Emitting Particles
	part_emitter_region(global.part_system_HUDAdd, bar.emitter1, bar.x, bar.x, bar.y, bar.y, ps_shape_ellipse, ps_distr_linear);
	part_emitter_burst(global.part_system_HUDAdd, bar.emitter1, bar.particle2, damagePercentage * 20);
	part_emitter_burst(global.part_system_HUDAdd, bar.emitter1, bar.particle1, damagePercentage * 200);
	
	// Start countdown back to normal
	bar.alarm[0] = damagePercentage * 70;
	bar.alarm[1] = 1;
	bar.image_speed = 0;
	
	// Partitions Positions
	bar.partitionsHeight += 7 * damagePercentage;
	bar.partitionsPosition += 20 * damagePercentage;
}