function superstate_create() { // Creates a superstate machine
	var superstate = {}
	superstate.stateMachineList = ds_list_create();
	superstate.stateMachineMap = ds_map_create();
	
	return superstate;
}