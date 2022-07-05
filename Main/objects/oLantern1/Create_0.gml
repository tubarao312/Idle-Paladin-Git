image_index = random_range(0, 10);

lightFlickerFrequency = 0.0075 * random_range(0.95, 1.05);
lightFlickerOffset = random_range(0, 10000); // Offset so that lights don't flicker in sync

lightCircleSmall = {
	minRadius: smallLanternMinRadius,
	bonusRadius: smallLanternBonusRadius,
	color: $57ebff,
	alpha: 0.25,
}

lightCircleBig = {
	minRadius: bigLanternMinRadius,
	bonusRadius: bigLanternBonusRadius,
	color: $57ebff,
	alpha: 0.25,
}

function draw_light_circle(lightCircle, size, X, Y) { // Size goes from 0 to 1
	draw_set_alpha(lightCircle.alpha);
	
	var radius = lightCircle.minRadius + lightCircle.bonusRadius * size;

	draw_circle_color(X, Y, floor(radius*2)/2, lightCircle.color, lightCircle.color, false);
	
	draw_set_alpha(1);
}


