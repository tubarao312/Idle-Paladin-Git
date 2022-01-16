function superstate_update(state){
	var i;
	for (i = 0; i < ds_list_size(state.stateMachineList); i++) {
		var stateMachine = state.stateMachineList[|i];
		currentStateMachine = stateMachine;
		
		state_machine_update(stateMachine);
	}
}