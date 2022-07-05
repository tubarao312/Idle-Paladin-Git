function perk_add(itemInstance, perkID, rank) {
	var perk = {};
	perk.rank = rank;
	perk.bp = perkID;
	
	ds_list_add(itemInstance.perkList, perk);
	
	return perk;
}