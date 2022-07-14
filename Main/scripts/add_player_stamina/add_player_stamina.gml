function add_player_stamina(stamina) {
	var bar = oHUDStaminaBar;
	
	if stamina < 0 {
		var intensity = abs(stamina / playerStats.maxStamina) * 2;
		
		bar.xShakeOffset = intensity * random_sign() * random_range(11, 15);
		bar.yShakeOffset = intensity * random_sign() * random_range(11, 15);
		bar.outerCircleImageIndex += intensity * 2.5;
	}
	
	currentPlayerStats.stamina += stamina;
}