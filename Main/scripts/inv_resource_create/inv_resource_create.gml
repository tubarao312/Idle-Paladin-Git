function inv_resource_create(name) {
	var inventory = {};
	inventory.name = name;
	inventory.itemList = ds_list_create();
	inventory.itemMap = ds_list_create();
	
	ds_map_add(global.resourceInventoryMap, name, inventory);
	
	return inventory;
}