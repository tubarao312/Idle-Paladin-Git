
gpu_set_blendmode(bm_add)
draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,image_yscale,image_angle,col,round(alpha*4)/4)
gpu_set_blendmode(bm_normal)

alpha = lerp(alpha,0,alphaDecay)
image_xscale = lerp(image_xscale,0,0.02)
image_angle = lerp(image_angle,targetAngle,0.05)

if alpha <= 0.1 then instance_destroy()