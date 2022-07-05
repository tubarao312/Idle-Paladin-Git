function superstate_machine_update(machine){
	if machine.superstate != noone then superstate_update(machine.superstate);
}