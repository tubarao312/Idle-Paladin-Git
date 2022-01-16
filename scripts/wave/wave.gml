
///@arg from
///@arg to
///@arg duration
///@arg offset

//wave(from, to, duration, offset)

// Returns a value that will wave back and forth between [from-to] over [duration] seconds
// Examples
//      image_angle = Wave(-45,45,1,0)  -> rock back and forth 90 degrees in a second
//      x = Wave(-10,10,0.25,0)         -> move left and right quickly
 
 
function wave(arg0,arg1,arg2,arg3) {
	var a4 = (argument1 - argument0) * 0.5;
	
	return argument0 + a4 + sin((((current_time * 0.001) + argument2 * 1) / argument2) * (pi*2)) * a4;
}