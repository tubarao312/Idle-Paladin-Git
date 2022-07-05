draw_self();

if whiteAlpha > 0 {
	whiteAlpha = lerp(whiteAlpha,-0.1,0.05);
	
	gpu_set_fog(true,c_white,0,1);
	gpu_set_blendmode(bm_add);
	draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,image_yscale,image_angle,c_white,image_alpha*round(whiteAlpha*5)/5);
	gpu_set_fog(false,c_white,0,1);
	gpu_set_blendmode(bm_normal);

}