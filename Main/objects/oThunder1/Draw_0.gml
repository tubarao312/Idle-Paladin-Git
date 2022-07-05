gpu_set_blendmode(bm_add);
draw_sprite_ext(sprite_index,max(0,image_index-1),x,y,image_xscale,image_yscale,image_angle,c_white,0.1);
gpu_set_blendmode(bm_normal);

draw_self();