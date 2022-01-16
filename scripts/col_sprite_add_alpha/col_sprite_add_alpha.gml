function col_sprite_add_alpha(sprite, alpha) {
	sprite.alpha += alpha;
	
	sprite.alpha = clamp(sprite.alpha, 0, 1);
}