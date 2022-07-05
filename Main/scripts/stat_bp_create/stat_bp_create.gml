function stat_bp_create(name, statCol, iconSprite, prefixStr, sufixStr) {
	var statBP = {};
	statBP.name = name;
	statBP.statCol = statCol;
	statBP.iconSprite = iconSprite;
	statBP.prefixStr = prefixStr;
	statBP.sufixStr = sufixStr;
	
	ds_map_add(global.statBlueprintMap, name, statBP);
	
	return statBP;
}

enum STAT_COLORS {
	white,
	yellow,
	orange,
}