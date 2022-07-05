playerStats.currentHP = clamp(playerStats.currentHP, 0, playerStats.maxHP);
percentageHP = playerStats.currentHP / playerStats.maxHP;

// Drawing all the partitions
partitionsHeight = lerp(partitionsHeight, 0, 0.1);
partitionsPosition = lerp(partitionsPosition, 0, 0.1);

var i;
for (i = 0; i < HPPartitions * percentageHP; i++) {
	var waveEffectY = sin(partitionsPosition + 3.14 * i / 5) * partitionsHeight;
	
	draw_sprite_ext(HPPartitionSprite, 0, 8 + x + (i * 5) + barShakeX, y - 1 + barShakeY + waveEffectY,
		1 + 0.15 * abs(waveEffectY),  1 + 0.15 * abs(waveEffectY), 0, c_white, 1);
}

// Last Partition has a different sprite
waveEffectY = sin(partitionsPosition + 3.14 * i / 5) * partitionsHeight;
draw_sprite_ext(HPPartitionSprite, 1, 8 + x + (i * 5) + barShakeX, y - 1 + barShakeY + waveEffectY,
		image_xscale + 0.15 * abs(waveEffectY),  image_yscale + 0.15 * abs(waveEffectY), 0, c_white, 1);

draw_sprite_ext(sprite_index, image_index, x + heartShakeX, y + heartShakeY, image_xscale, image_yscale, 0, c_white, 1);

// Text
draw_set_font(font);
draw_text(x + 1 + textShakeX, y + textShakeY - 4, string(floor(playerStats.currentHP)) + " HP");

// Shaking Position
xRel = lerp(-xRel, 0, 0.3);
yRel = lerp(-yRel, 0, 0.3);

barShakeX = lerp(-barShakeX, 0, 0.3);
barShakeY = lerp(-barShakeY, 0, 0.3);

heartShakeX = lerp(-heartShakeX, 0, 0.3);
heartShakeY = lerp(-heartShakeY, 0, 0.3);

textShakeX = lerp(-textShakeX, 0, 0.3);
textShakeY = lerp(-textShakeY, 0, 0.3);

// Shaking Size
image_xscale = lerp(image_xscale, 1, 0.2);
image_yscale = lerp(image_yscale, 1, 0.2);

if image_xscale <= 1.1 then image_xscale = 1;
if image_yscale <= 1.1 then image_yscale = 1;

// Leaving Screen
xSpd = lerp(xSpd, (originalX - (!global.showHUD) * 30 - xCreate) / 2, 0.25);
ySpd = lerp(ySpd, (originalY - (!global.showHUD) * 30 - yCreate) / 2, 0.25);
xCreate += xSpd;
yCreate += ySpd;