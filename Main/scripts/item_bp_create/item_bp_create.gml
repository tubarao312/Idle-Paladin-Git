// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function item_bp_create(name, type, sprite, rarity){
	var itemBP = {};
	itemBP.name = name;
	itemBP.type = type;
	itemBP.sprite = sprite;
	itemBP.rarity = rarity;
	itemBP.alphabeticOrder = 1;
	itemBP.set = noone;
	
	ds_list_add(global.itemAlphabeticList, itemBP.name);
	ds_map_add(global.itemBlueprintMap, itemBP.name, itemBP);
	
	return itemBP;
}