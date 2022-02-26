event_inherited();

surface = surface_create(global.windowW, global.windowH);

abilityDash = { // Dash Ability
	sprite: sAbilityIconDash,
	manaCost: 1,
	manaCostFont: global.fontHopeCommon,
};

abilityShield = { // Shield Ability
	sprite: sAbilityIconShield,
	manaCost: 3,
	manaCostFont: global.fontHopeCommon,
};

abilityFireball = { // Fireball Ability
	sprite: sAbilityIconFireball,
	manaCost: 2,
	manaCostFont: global.fontHopeCommon,
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
	
	// Draw Icon
	draw_sprite_ext(ability.sprite, (abilitySlot.promptPressedTimer > 0), abilityX, abilityY, max(0.55, abilitySlot.size), max(0.55, abilitySlot.size), abilitySlot.image_angle, c_white, 1);

	// For calculating positions of the corners of the main icon
	var width = sprite_get_width(ability.sprite);
	var height = sprite_get_height(ability.sprite);

	// Count Down Prompt Timer
	if abilitySlot.promptPressedTimer > 0 then abilitySlot.promptPressedTimer --;
	
	// Draw Controller Prompt
	draw_sprite(promptSprite, (abilitySlot.promptPressedTimer > 0), X - width/2 + 5 + abilitySlot.promptShakeX, Y - height/2 + 4 + abilitySlot.promptShakeY);
	
	// Draw Cost
	//draw_set_font(ability.manaCostFont);
	//draw_text(X + width/2 - 5 + abilitySlot.manaCostShakeX, Y + height/2 - 9 + abilitySlot.manaCostShakeY, ability.manaCost);
}