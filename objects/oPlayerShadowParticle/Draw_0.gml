gpu_set_blendmode(bm_add);
gpu_set_fog(true,$f9cd00,0,1);
draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,image_yscale,0,0, round((alpha + wave(-0.1, 0.1, 30, 0))*4)/4);
gpu_set_fog(false,c_white,0,1);
gpu_set_blendmode(bm_normal);