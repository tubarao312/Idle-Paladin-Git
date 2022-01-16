function perk_rank_create(perkBP, description) {
	var tier = {};
	tier.description = description;
	
	ds_list_add(perkBP.rankList, tier);
}