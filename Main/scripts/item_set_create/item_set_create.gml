///@arg name
///@arg baseRarity

function item_set_create(name, baseRarity) {
	var set = {};
	set.name = name;
	set.baseRarity = baseRarity;
	set.itemList = ds_list_create();
	set.tierList = ds_list_create();

	ds_map_add(global.itemSetMap, name, set);

	return set;	
}