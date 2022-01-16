if point_distance(x,y,oPlayer.x,oPlayer.y) < 50 {
	alpha = lerp(alpha, 1, 0.075);
} else {
	alpha = lerp(alpha, 0, 0.25);
}