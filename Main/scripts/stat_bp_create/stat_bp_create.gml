function stat_bp_create(name, statCol, iconSprite, ID, prefixStr, sufixStr) {
	var statBP = {};
	statBP.name = name;
	statBP.statCol = statCol;
	statBP.iconSprite = iconSprite;
	statBP.prefixStr = prefixStr;
	statBP.sufixStr = sufixStr;
	statBP.ID = ID;
	
	ds_map_add(global.statBlueprintMap, name, statBP);
	ds_map_add(global.statBlueprintMap, ID, statBP);
	
	return statBP;
}

enum STAT_COLORS {
	white,
	yellow,
	orange,
}