function inv_stackable_create(name) {
	var inventory = {};
	inventory.name = name;
	inventory.items = ds_list_create();
	
	ds_map_add(global.uniqueInventoryMap, name, inventory);
	
	return inventory;
}