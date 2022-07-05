function item_instance_set_level(item, level) {
	item.level = level;
	
	ds_priority_change_priority(item.inv.itemsByLevel, item, level);
}