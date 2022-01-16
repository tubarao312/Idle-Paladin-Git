x += dcos(trajectoryAngle) * spd;
y += dsin(trajectoryAngle) * spd;
angle += spd * 3;

drawDistanceFromCenter = lerp(drawDistanceFromCenter, 0, 0.01);

draw_sprite_ext(sprite_index, image_index,
	x + dcos(angle) * drawDistanceFromCenter,
	y + dsin(angle) * drawDistanceFromCenter, 
	image_xscale, image_yscale, angle,
	c_white, 1);