function state_machine_start_state(superstateMachine, stateMachineName, stateName) {
	var stateMachine = superstateMachine.superstate.stateMachineMap[? stateMachineName];
	
	if ds_map_exists(stateMachine.stateMap, stateName) {
		ds_stack_push(stateMachine.stateStack, stateMachine.stateMap[?stateName]);
		state_machine_set_update_type(stateMachine, STATE_UPDATE_TYPE.start)
	}
}