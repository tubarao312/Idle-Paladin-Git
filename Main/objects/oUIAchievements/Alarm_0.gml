/// @description ShowUp Animation

if rotatedFrames < ds_list_size(global.achievementList) {
	global.achievementList[| rotatedFrames].imgSpd = 0.3;
	alarm[0] = 3;
	rotatedFrames ++;
}