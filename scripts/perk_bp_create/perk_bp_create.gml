function perk_bp_create(name, sprite) {
	var perkBP = {};
	perkBP.name = name;
	perkBP.sprite = sprite;
	perkBP.rankList = ds_list_create();
	
	ds_map_add(global.perkBlueprintMap, name, perkBP);
	
	return perkBP;
}