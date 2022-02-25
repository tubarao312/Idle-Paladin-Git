function resource_create(name, sprite, rarity) {
	var resource = {};
	resource.name = name;
	resource.sprite = sprite;
	resource.rarity = rarity;

	ds_list_add(global.resourceBPLIst, resource);
	ds_map_add(global.resourceBPMap, name, resource);

	return resource;
}