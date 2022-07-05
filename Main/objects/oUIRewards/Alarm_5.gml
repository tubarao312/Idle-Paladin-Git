/// @description Item 2
if item2UpgCount > item2UpgCountDisplayed {
	var nextTimer = 18 - (item2UpgCount - item2UpgCountDisplayed);

	alarm[5] = nextTimer;
	whiteAlphaItem2 = 0.8;
	item2UpgCountDisplayed ++;
	item_increase_level(item2);
	oUIItemShop.redrawItemDesc = true;
	oUIItemShop.redrawThreeItems = true;
	
	part_emitter_region(global._part_system_2, global._part_emitter_4, x+84,x+108,y+36,y+75, ps_shape_rectangle, ps_distr_linear)
	part_emitter_burst(global._part_system_2,global._part_emitter_4,global._part_type_13,3)
	if chance(0.5) part_emitter_burst(global._part_system_2,global._part_emitter_4,global._part_type_14,1)
}