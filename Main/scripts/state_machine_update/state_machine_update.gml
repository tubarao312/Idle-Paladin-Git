enum STATE_UPDATE_TYPE {
	start,
	step,
	finish,
}

function state_machine_update(stateMachine){
	currentStateMachine = stateMachine;
	var state = state_machine_get_current_state(stateMachine);
	
	if state != undefined then {
		var type = state.updateType;
		
		switch type {
			case STATE_UPDATE_TYPE.start: { // Running code for when the state begins
				state.start();
				state.step();
				if state.updateType != STATE_UPDATE_TYPE.finish then state.updateType = STATE_UPDATE_TYPE.step;
			break; }
			case STATE_UPDATE_TYPE.step: { // Running code for when the state is happening
				state.step();
			break; }
			case STATE_UPDATE_TYPE.finish: { // Running code for when the state finishes
				state.step();
				state.finish();
			
				ds_stack_pop(stateMachine.stateStack);
			
				if stateMachine.queuedState != undefined { // State queueing, replaces state
					ds_stack_push(stateMachine.stateStack, stateMachine.queuedState);
					stateMachine.queuedState = undefined;	
				}
			
				state.updateType = STATE_UPDATE_TYPE.start;
			break; }
		}
	}
	
}