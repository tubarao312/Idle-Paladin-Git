/// @description Item 1
if item1UpgCount <= item1UpgCountDisplayed {
	alarm[5] = 5;
} else {
	var nextTimer = 18 - (item1UpgCount - item1UpgCountDisplayed);

	alarm[4] = nextTimer;
	whiteAlphaItem1 = 0.7;
	item1UpgCountDisplayed ++;
	item_increase_level(item1);
	oUIItemShop.redrawItemDesc = true;
	oUIItemShop.redrawThreeItems = true;
	
	part_emitter_region(global._part_system_2, global._part_emitter_4, x+114,x+138,y+36,y+75, ps_shape_rectangle, ps_distr_linear)
	part_emitter_burst(global._part_system_2,global._part_emitter_4,global._part_type_13,3)
	if chance(0.5) part_emitter_burst(global._part_system_2,global._part_emitter_4,global._part_type_14,1)
	
}