function effect_remove(effect) {
	ds_priority_delete_value(global.currentFrameEffects.queue, effect);
	ds_map_delete(global.currentFrameEffects.map, effect.name);
	
	delete effect;
}