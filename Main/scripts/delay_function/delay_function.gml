function delay_function(owner, func, functionVariables, timer){
	delayedFunction = {};
	delayedFunction.owner = owner;
	delayedFunction.execute_function = func;
	delayedFunction.timer = timer;
	delayedFunction.functionVariables = functionVariables;
	
	ds_list_add(global.delayedFunctions,  delayedFunction);
}