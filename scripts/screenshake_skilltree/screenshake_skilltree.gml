/// @desc Screenshake(magnitude_frames)
/// @arg Magnitude sets the stregth of the shake
/// @arg Frames sets the duration
function screenshake_skilltree(argument0, argument1) {
	with (oUISkillTree) {
	    if (argument0 > shake_remain) {
	        shake_magnitude = argument0
	        shake_remain = argument0
	        shake_length = argument1
	    }
	}
}
