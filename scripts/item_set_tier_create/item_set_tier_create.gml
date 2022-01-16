function item_set_tier_create(set, piecesRequired, description) {
	var tier = {};
	tier.piecesRequired = piecesRequired;
	tier.description = description;
	
	ds_list_add(set.tierList, tier);
}