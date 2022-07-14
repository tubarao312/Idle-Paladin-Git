// Adds together all the stats of the currently equipped items, each
// stat on the returned array is in the position of its ID (creation order)
function get_equipped_item_stats() {
	var stats = array_create(ds_list_size(global.statBlueprintList), 0);
	
	var i, j;
	for (i = 0; i < ITEM_TYPES.size; i++) {
		var item = global.equippedItems[i];
		
		if item != noone { // Item must be equipped
			print(item);
			var itemStats = item_instance_get_stats(item);
			for (j = 0; j < ds_list_size(itemStats); j++) {
				var stat = itemStats[|j];
				stats[stat_get_id(stat.bp)] += stat_get_quantity(stat);
			}
		}
	}

	return stats;
}