function state_machine_reset_states(stateMachine){
	ds_stack_destroy(stateMachine.stateStack);
	stateMachine.stateStack = ds_stack_create();
}