function perk_tier_add(perkName, tierNumber, description) {
	var perkTier = {};
	perkTier.tierNumber = tierNumber;
	perkTier.description = description;
	
	ds_list_add(global.perkBlueprintMap[?perkName].rankList, perkTier);
	
	return perkTier;
}