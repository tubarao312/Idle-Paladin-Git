function state_machine_set_update_type(stateMachine, type) {
	state_machine_get_current_state(stateMachine).updateType = type;
}