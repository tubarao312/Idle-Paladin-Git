// Sprite
if instance_exists(oPlayer) then image_index = !oPlayer.physics.onGround

// Shake
shakeX += random_range(-shake, shake);
shakeY += random_range(-shake, shake);

x = oPlayer.x + shakeX;
y = oPlayer.y + shakeY;

shakeX = lerp(shakeX, 0, 0.1);
shakeY = lerp(shakeY, 0, 0.1);
shake = lerp(shake, 0, 0.1);

// Stretch
stretchX = lerp(stretchX, 0, 0.05);
stretchY = lerp(stretchY, 0, 0.05);


if stretchX > 0.1 then stretchTimerX += 20 else {
	stretchTimerX = 0;
	stretchX = 0;
}

if stretchY > 0.1 then stretchTimerY += 20 else {
	stretchTimerY = 0;
	stretchY = 0;
}

// Alpha Shake
image_alpha += random_range(-alphaShake/3, alphaShake);
alphaShake = lerp(alphaShake, 0, 0.15);
image_alpha = lerp(image_alpha, 0.45 + dsin(current_time/100)*0.1, 0.1);

gpu_set_blendmode(bm_add);
draw_self();
gpu_set_blendmode(bm_normal);
draw_self();