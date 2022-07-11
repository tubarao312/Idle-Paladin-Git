playerStats.currentMana = clamp(playerStats.currentMana, 0,playerStats. maxMana);

// Drawing all the partitions
partitionsHeight = lerp(partitionsHeight, 0, 0.1);
partitionsPosition = lerp(partitionsPosition, 0, 0.1);

var i;
for (i = 0; i < floor(playerStats.currentMana); i++) {
	var waveEffectY = sin(partitionsPosition + 3.14 * i / 5) * min(partitionsHeight, 10);
	
	if global.enableHUD then  draw_sprite_ext(manaPartitionSprite, 0, x - 12 - (i * 11) + barShakeX, y + 9 + barShakeY + waveEffectY,
		1 + 0.1 * abs(waveEffectY),  1 + 0.1 * abs(waveEffectY), 0, c_white, 1);
}

// Last Mana Partition
var waveEffectY = sin(partitionsPosition + 3.14 * i / 5) * partitionsHeight;
var subimg = (playerStats.currentMana - floor(playerStats.currentMana)) * 9;

if global.enableHUD then draw_sprite_ext(sHUDManaBarPart, subimg, x - 12 - (i * 11) + barShakeX, y + 9 + barShakeY + waveEffectY,
	1 + 0.1 * abs(waveEffectY),  1 + 0.1 * abs(waveEffectY), 0, c_white, 1);

// Drawing Sprite Itself
if global.enableHUD then draw_sprite_ext(sprite_index, image_index, x + ballShakeX - 6, y + ballShakeY + 8, image_xscale, image_yscale, 0, c_white, 1);

// Text
draw_set_font(font);
draw_set_halign(fa_right);
if floor(playerStats.currentMana) > 0 {
	if global.enableHUD then draw_text(x - 38 + textShakeX, y + textShakeY + 4, floor(playerStats.currentMana));
}
draw_set_halign(fa_left);

if global.enableHUD then draw_sprite(textSprite, 0, x - 34 + textShakeX, y + textShakeY + 9)

// Shaking Position
xRel = lerp(-xRel, 0, 0.3);
yRel = lerp(-yRel, 0, 0.3);

barShakeX = lerp(-barShakeX, 0, 0.3);
barShakeY = lerp(-barShakeY, 0, 0.3);

ballShakeX = lerp(-ballShakeX, 0, 0.3);
ballShakeY = lerp(-ballShakeY, 0, 0.3);

textShakeX = lerp(-textShakeX, 0, 0.3);
textShakeY = lerp(-textShakeY, 0, 0.3);

// Shaking Size
image_xscale = lerp(image_xscale, 1, 0.2);
image_yscale = lerp(image_yscale, 1, 0.2);

if image_xscale <= 1.1 then image_xscale = 1;
if image_yscale <= 1.1 then image_yscale = 1;

// Leaving Screen
xSpd = lerp(xSpd, (originalX + (!global.showHUD) * 30 - xCreate) / 2, 0.25);
ySpd = lerp(ySpd, (originalY - (!global.showHUD) * 30 - yCreate) / 2, 0.25);
xCreate += xSpd;
yCreate += ySpd;


function add_mana(mana) { // Adds Mana
	playerStats.currentMana += mana;
	
	mana = abs(mana);
	mana = clamp(mana, 0.2, 0.75)
	
	// Changing bar to orange color
	sprite_index = sHUDManaBarBallGlowing;
	manaPartitionSprite = sHUDManaBarFullGlowing;
	
	// Starting bar shake
	if mana < 0 {
		xRel = random_sign() * mana * 6;
		yRel = random_sign() * mana * 6;
	}
	
	image_xscale = 1 + random_range(0.5, 1) * mana * 0.35;
	image_yscale = 1 + random_range(0.5, 1) * mana * 0.35;
	
	barShakeX = random_sign() * mana * 2.5;
	barShakeY = random_sign() * mana * 2.5;
	
	heartShakeX = random_sign() * mana * 2.5;
	heartShakeY = random_sign() * mana * 2.5;
	
	textShakeX = random_sign() * mana * 2.5;
	textShakeY = random_sign() * mana * 2.5;
	
	// Changing Font
	font = global.fontHopeManaGlowing;
	textSprite = sHUDManaBarTextGlowing;
	
	// Emitting Particles
	part_emitter_region(global.part_system_HUDAdd, emitter1, x + 8 - 8, x - 8 - 8, y + 8 + 8, y - 8 + 8, ps_shape_ellipse, ps_distr_linear);
	part_emitter_burst(global.part_system_HUDAdd, emitter1, particle2, mana * 35);
	part_emitter_burst(global.part_system_HUDAdd, emitter1, particle1, mana * 45);
	
	// Start countdown back to normal
	alarm[0] = mana * 20;
	image_speed = 0;
	
	// Partitions Positions
	partitionsHeight += 4.5 * mana;
	partitionsPosition += 20 * mana;
}

if keyboard_check_pressed(ord("R")) then add_player_mana(random_range(0.5, 2));