function state_machine_queue_state(superstateMachine, stateMachineName, stateName){
	var stateMachine = superstateMachine.superstate.stateMachineMap[? stateMachineName];
	
	if ds_map_exists(stateMachine.stateMap, stateName) {
		stateMachine.queuedState = stateMachine.stateMap[?stateName];
	}
}