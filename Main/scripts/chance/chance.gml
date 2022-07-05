///@arg 0 to 1 float
function chance(value){
	var numberGen = random_range(0,1)
	
	return (numberGen <= value)
}