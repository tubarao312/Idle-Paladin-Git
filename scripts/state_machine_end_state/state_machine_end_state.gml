function state_machine_end_state(superstateMachine, stateMachineName)
{	
	var stateMachine = superstateMachine.superstate.stateMachineMap[?stateMachineName];
	state_machine_set_update_type(stateMachine, STATE_UPDATE_TYPE.finish);
	
}