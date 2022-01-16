function state_machine_create(name) {
	var stateMachine = {}
	stateMachine.stateStack = ds_stack_create();
	stateMachine.stateMap = ds_map_create();
	stateMachine.name = name;
	stateMachine.queuedState = undefined;
	
	return stateMachine;
}