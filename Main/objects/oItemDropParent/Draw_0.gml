draw_self()

if startDestroying {
	disappearAlpha = lerp(disappearAlpha,2,0.05)
	
	gpu_set_fog(true,c_white,0,1)
	gpu_set_blendmode(bm_add)
	draw_set_alpha(disappearAlpha)
	draw_self();
	draw_set_alpha(1)
	gpu_set_blendmode(bm_normal)
	gpu_set_fog(false,c_white,0,1)
}