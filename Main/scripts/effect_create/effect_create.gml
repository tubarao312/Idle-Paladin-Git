function effect_create(step, name, attributes) {
	var effect = {};
	
	effect.step = step;
	effect.name = name;
	effect.attributes = attributes;
	
	return effect;
}