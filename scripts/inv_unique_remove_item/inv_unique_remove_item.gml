function inv_unique_remove_item(inv, item) {
	
	// Adding to item listt
	ds_list_delete(inv.items, ds_list_find_value(inv.items, item));
	
	// For sorting purposes
	ds_priority_delete_value(inv.itemsByLevel, item);
	ds_priority_delete_value(inv.itemsByType, item);
	ds_priority_delete_value(inv.itemsByName, item);
	ds_priority_delete_value(inv.itemsByRarity, item);

	item.currentInventory = noone;
}