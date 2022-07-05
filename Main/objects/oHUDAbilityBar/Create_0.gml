event_inherited();

surface = surface_create(global.windowW, global.windowH);

abilityDash = { // Dash Ability
	sprite: sAbilityIconDash,
	manaCost: 1,
	manaCostFont: global.fontHopeCommon,
	lightCol: $fff10c,
};

abilityShield = { // Shield Ability
	sprite: sAbilityIconShield,
	manaCost: 3,
	manaCostFont: global.fontHopeCommon,
	lightCol: $7efcd3,
};

abilityFireball = { // Fireball Ability
	sprite: sAbilityIconFireball,
	manaCost: 1.5,
	manaCostFont: global.fontHopeCommon,
	lightCol: $50abed,
};
	

function ability_slot_create(ability) {
	var abilitySlot = {
	
	// Main Icon
	bonusX: 0,
	bonusY: 0,
	
	shakeX: 0,
	shakeY: 0,
	shakePosition: 0,

	image_angle: 0,
	shakeAngle: 0,

	size: 1, // image_xscale and image_yscale
	shakeSize: 0,
	
	// Command Prompt
	promptShakeX: 0,
	promptShakeY: 0,
	promptShakePosition: 0,
	
	promptPressedTimer: 0, // Counts down to 0. When 0, it's not pressed
	
	// Mana Cost
	manaCostShakeX: 0,
	manaCostShakeY: 0,
	manaCostShakePosition: 0,
	
	// The ability that's assigned to this slot,
	// to be removed once system is made fully modular
	ability: ability,
	}

	return abilitySlot;
}

abilitySlots = [
	ability_slot_create(abilityShield), 
	ability_slot_create(abilityDash),
	ability_slot_create(abilityFireball)];
	
abilitySlotPrompts = [
	sPromptDS4Triangle,
	sPromptDS4Circle,
	sPromptDS4Square];

function draw_ability_slot(abilitySlot, promptSprite, X, Y) {
	var ability = abilitySlot.ability;
	
	// Handling Position Shake (Ability Icon)
	abilitySlot.shakeX += random_range(-abilitySlot.shakePosition, abilitySlot.shakePosition);
	abilitySlot.shakeY += random_range(-abilitySlot.shakePosition, abilitySlot.shakePosition);
	
	abilitySlot.shakeX = lerp(abilitySlot.shakeX, 0, 0.15);
	abilitySlot.shakeY = lerp(abilitySlot.shakeY, 0, 0.15);
	
	abilitySlot.shakePosition = lerp(abilitySlot.shakePosition, 0, 0.15);
	
	// Handling Position Shake (Mana Cost)
	abilitySlot.manaCostShakeX += random_range(-abilitySlot.manaCostShakePosition, abilitySlot.manaCostShakePosition);
	abilitySlot.manaCostShakeY += random_range(-abilitySlot.manaCostShakePosition, abilitySlot.manaCostShakePosition);
	
	abilitySlot.manaCostShakeX = lerp(abilitySlot.manaCostShakeX, 0, 0.15);
	abilitySlot.manaCostShakeY = lerp(abilitySlot.manaCostShakeY, 0, 0.15);
	
	abilitySlot.manaCostShakePosition = lerp(abilitySlot.manaCostShakePosition, 0, 0.15);
	
	// Handling Position Shake (Prompt)
	abilitySlot.promptShakeX += random_range(-abilitySlot.promptShakePosition, abilitySlot.promptShakePosition);
	abilitySlot.promptShakeY += random_range(-abilitySlot.promptShakePosition, abilitySlot.promptShakePosition);
				
	abilitySlot.promptShakeX = lerp(abilitySlot.promptShakeX, 0, 0.15);
	abilitySlot.promptShakeY = lerp(abilitySlot.promptShakeY, 0, 0.15);
				
	abilitySlot.promptShakePosition = lerp(abilitySlot.promptShakePosition, 0, 0.15);
	
	// Handling Rotation Shake
	abilitySlot.image_angle += random_range(-abilitySlot.shakeAngle, abilitySlot.shakeAngle);
	abilitySlot.image_angle = lerp(abilitySlot.image_angle, 0, 0.15);
	abilitySlot.shakeAngle = lerp(abilitySlot.shakeAngle, 0, 0.15);
	
	// Handling Size Shake
	abilitySlot.size += random_range(-abilitySlot.shakeSize, abilitySlot.shakeSize);
	abilitySlot.size = lerp(abilitySlot.size, 1, 0.15);
	abilitySlot.shakeSize = lerp(abilitySlot.shakeSize, 0, 0.15);
	
	// Calculate X and Y coords to draw at
	var abilityX = X + abilitySlot.bonusX + abilitySlot.shakeX;
	var abilityY = Y + abilitySlot.bonusY + abilitySlot.shakeY;
	
	// Check if cursor is hovering button
	abilitySlot.hovered = cursor_in_box(X + 13, Y + 13, X - 13, Y - 13);
	if ability.manaCost <= playerStats.currentMana and abilitySlot.hovered then cursor_skin(1);
	if ability.manaCost <= playerStats.currentMana and abilitySlot.hovered and oPlayer.inputs.mbLeft[PRESSED] then press_ability_slot(abilitySlot);
	
	// Draw Glowing Light
	if abilitySlot.promptPressedTimer > 0 {
		draw_sprite_ext(sAbilityIconGlow, (1 - abilitySlot.promptPressedTimer / 23) * 11.99, abilityX, abilityY, 1, 1, abilitySlot.image_angle, ability.lightCol, ceil((abilitySlot.promptPressedTimer / 23) * 6) / 6);
	}
	
	// Draw Icon
	var iconSubimg;
	if abilitySlot.promptPressedTimer > 0 then iconSubimg = 1;
	else if ability.manaCost > playerStats.currentMana then iconSubimg = 2;
	else if abilitySlot.hovered then iconSubimg = 1;
	else iconSubimg = 0;
	
	draw_sprite_ext(ability.sprite, iconSubimg, abilityX, abilityY, max(0.55, abilitySlot.size), max(0.55, abilitySlot.size), abilitySlot.image_angle, c_white, 1);

	// For calculating positions of the corners of the main icon
	var width = sprite_get_width(ability.sprite);
	var height = sprite_get_height(ability.sprite);

	// Count Down Prompt Timer
	if abilitySlot.promptPressedTimer > 0 then abilitySlot.promptPressedTimer --;
	
	// Draw Controller Prompt
	var promptSubimg;
	if abilitySlot.promptPressedTimer > 0 then promptSubimg = 1;
	else if ability.manaCost > playerStats.currentMana then promptSubimg = 2;
	else promptSubimg = 0;
	
	draw_sprite(promptSprite, promptSubimg, X - width/2 + 5 + abilitySlot.promptShakeX, Y - height/2 + 4 + abilitySlot.promptShakeY);
	
	// Draw Cost
	//draw_set_font(ability.manaCostFont);
	//draw_text(X + width/2 - 5 + abilitySlot.manaCostShakeX, Y + height/2 - 9 + abilitySlot.manaCostShakeY, ability.manaCost);
}
	
function press_ability_slot(slot) {
	slot.shakePosition = 4.5;
	slot.promptShakePosition = 2;
	slot.manaCostShakePosition = 1.5;
	slot.shakeAngle = 15;
	slot.shakeSize = 0.15;
	slot.promptPressedTimer = 23;
	slot.size = 0.65;
	
	oPlayer.alarm[11] = 15;
}