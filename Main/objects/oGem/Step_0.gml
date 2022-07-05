/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

if alarm[0] <= 0 and point_distance(x,y,oPlayer.x,oPlayer.y) < 25 {
	ogX = lerp(ogX,oPlayer.x,0.25)
	ogY = lerp(ogY,oPlayer.y,0.25)
}