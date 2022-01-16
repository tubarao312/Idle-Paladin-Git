function state_machine_add_state(stateMachine, state){
	ds_map_add(stateMachine.stateMap, state.name, state);
	stateMachine.stateMap[?state.name] = state;
}