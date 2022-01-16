function col_sprite_draw(sprite, sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle) {
	
	if sprite.alpha > 0 {
		gpu_set_fog(true, sprite.col, 0, 1);
		gpu_set_blendmode(sprite.blendmode);
		draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, round(sprite.alpha*4)/4);
		gpu_set_blendmode(bm_normal);
		gpu_set_fog(false,c_white,0,1);
	}
}