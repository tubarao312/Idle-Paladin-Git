function state_machine_set_update_type(stateMachine, type) {
	var currentState = state_machine_get_current_state(stateMachine);
	if currentState != undefined then currentState.updateType = type;
}