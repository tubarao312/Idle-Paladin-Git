function effect_get(effectName) {
	return ds_map_find_value(global.currentFrameEffects.map, effectName);
}