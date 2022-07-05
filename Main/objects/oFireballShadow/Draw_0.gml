gpu_set_blendmode(bm_add)
gpu_set_fog(true,$1476ed,0,1)
draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,image_yscale,0,0, alpha+wave(-0.1,0.1,30,0));
gpu_set_fog(false,c_white,0,1)
gpu_set_blendmode(bm_normal)