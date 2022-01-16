function state_create(name, start, step, finish){
	var state = {};
	state.start = start;
	state.step = step;
	state.finish = finish;
	state.updateType = STATE_UPDATE_TYPE.start;
	
	state.name = name;
	
	
	return state;
}