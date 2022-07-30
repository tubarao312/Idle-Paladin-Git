function effect_add(effect, priority) {
	
	ds_priority_add(global.currentFrameEffects.queue, effect, priority);
	ds_map_add(global.currentFrameEffects.map, effect.name, effect);
}