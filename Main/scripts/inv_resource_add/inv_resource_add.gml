function inv_resource_add(inventory, itemBP, quantity) {
	if !ds_list_find_value(inventory.items, itemBP) { // If the inventory doesn't have this item
		ds_list_add(inventory.itemList, itemBP);
		ds_map_add(inventory.itemMap, itemBP, quantity);
	} else { // If the inventory already has the item blueprint registered
		inventory.itemMap[? itemBP] += quantity;
	}
}