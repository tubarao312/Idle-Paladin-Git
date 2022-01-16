
function superstate_clear_all_state_machines(superstate) {
	var i;
	
	for (i = 0; i < ds_list_size(superstate.stateMachineList); i++) {
		state_machine_reset_states(superstate.stateMachineList[|i]);
	}
}