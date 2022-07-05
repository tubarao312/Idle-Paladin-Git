function state_machine_get_current_state(stateMachine) {
	return ds_stack_top(stateMachine.stateStack);
}