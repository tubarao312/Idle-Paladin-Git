
box_set_layer(CURSOR_LAYERS.HUD); // Sets all boxes to the HUD layer

if !surface_exists(surface) then surface = surface_create(global.windowW, global.windowH);

surface_set_target(surface);
draw_clear_alpha(c_white, 0);
var currentSlot;
for (currentSlot = 0; currentSlot <= 2; currentSlot++) {
	draw_ability_slot(abilitySlots[currentSlot], abilitySlotPrompts[currentSlot], x - currentSlot * 31, y);
}
surface_reset_target();

if global.enableHUD then draw_surface(surface, 0, 0);

var q = keyboard_check_pressed(ord("Q"));
var w = keyboard_check_pressed(ord("E"));
var shift = keyboard_check_pressed(vk_shift);

if q or w or shift {
	var slot;
	
	if q then slot = abilitySlots[2];
	else if w then slot = abilitySlots[0];
	else slot = abilitySlots[1];
	
	if slot.ability.manaCost <= playerStats.currentMana then press_ability_slot(slot);
}