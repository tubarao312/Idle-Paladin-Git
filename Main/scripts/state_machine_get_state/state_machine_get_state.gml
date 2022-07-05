function state_machine_get_state(superstateMachine, stateMachineName, stateName){
	var stateMachine = superstateMachine.superstate.stateMachineMap[? stateMachineName];
	
	if ds_map_exists(stateMachine.stateMap, stateName) {
		return stateMachine.stateMap[?stateName];
	}
}