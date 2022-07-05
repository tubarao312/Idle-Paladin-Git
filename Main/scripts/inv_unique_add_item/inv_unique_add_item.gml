function inv_unique_add_item(inv, item) {
	
	// Adding to item list
	ds_list_add(inv.items, item);
	
	// For sorting purposes
	ds_priority_add(inv.itemsByLevel,  item, item.level);
	ds_priority_add(inv.itemsByType,   item, item.bp.type);
	ds_priority_add(inv.itemsByName,   item, item.bp.alphabeticOrder);
	ds_priority_add(inv.itemsByRarity, item, item.bp.rarity);
	
	item.currentInventory = inv;
}