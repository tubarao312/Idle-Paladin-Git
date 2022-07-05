function superstate_add_state_machine(superstate, stateMachine) {
	ds_list_add(superstate.stateMachineList, stateMachine);
	ds_map_add(superstate.stateMachineMap, stateMachine.name, stateMachine);
}