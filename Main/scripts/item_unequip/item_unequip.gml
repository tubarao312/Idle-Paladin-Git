function item_unequip(item){
	item.equippedCharacter = noone;
	
	global.equippedItems[item.bp.type] = noone;

	effect_remove_by_name(global.itemTypeNames[item.bp.type]);
}