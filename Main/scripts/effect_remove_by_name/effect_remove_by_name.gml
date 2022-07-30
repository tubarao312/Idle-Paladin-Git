function effect_remove_by_name(effectName) {
	var effect = effect_get(effectName)
	
	if effect != undefined {
		repeat 100 print(effectName);
		ds_priority_delete_value(global.currentFrameEffects.queue, effect);
		ds_map_delete(global.currentFrameEffects.map, effect.name);
	
		delete effect;
	}
}