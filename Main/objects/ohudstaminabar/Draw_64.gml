image_index = ceil(staminaPercentage * sprite_get_number(sprite_index) - 1);


if global.enableHUD {
	if !resting then draw_sprite_ext(sStaminaBarOuterCircle, min(outerCircleImageIndex, 2), floor(x), floor(y), 1, 1, 0, c_white, image_alpha);
	draw_sprite_ext(sprite_index, image_index, floor(x), floor(y), 1, 1, 0, c_white, image_alpha);
}