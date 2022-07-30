function effect_replace(effect, priority) {
	effect_remove_by_name(effect.name);
	effect_add(effect, priority);
}