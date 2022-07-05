function inv_unique_create(name) {
	var inventory = {};
	inventory.name = name;
	inventory.maxCapacity = -1; // -1 is unlimited
	inventory.items = ds_list_create();
	
	// Sorting
	inventory.itemsByName = ds_priority_create(); // A to Z through all the registered blueprints
	inventory.itemsByLevel = ds_priority_create(); // Priority = Level
	inventory.itemsByType = ds_priority_create(); // A to Z but manually done
	inventory.itemsByRarity = ds_priority_create(); // Priority = Rarity
	
	ds_map_add(global.uniqueInventoryMap, name, inventory);
	
	return inventory;
}