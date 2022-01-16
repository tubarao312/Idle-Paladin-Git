function col_sprite_create(colour, alpha, blendmode){
	sprite = {}
	sprite.col = colour;
	sprite.alpha = alpha;
	sprite.blendmode = blendmode;
	
	return sprite;
}