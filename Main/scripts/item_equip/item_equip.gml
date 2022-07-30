function item_equip(item){
	global.equippedItems[item.bp.type] = item;
	effect_replace(item_instance_get_effect(item), EFFECT_DEPTHS.statsAdd);
}