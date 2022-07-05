if !surface_exists(surFinal) then surFinal = surface_create(global.windowW, global.windowH);

gpu_set_blendmode_ext_sepalpha(bm_src_alpha,bm_inv_src_alpha,bm_src_alpha,bm_one);
draw_surface_ext(surFinal, 0, 0, 1, 1, 0, c_white, 1);
gpu_set_blendmode(bm_normal);

