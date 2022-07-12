function item_check_equipped(item){
	return (global.equippedItems[item.bp.type] = item);
}