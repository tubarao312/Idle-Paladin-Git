function item_unequip(item){
	item.equippedCharacter = noone;
	
	global.equippedItems[item.bp.type] = noone;
}