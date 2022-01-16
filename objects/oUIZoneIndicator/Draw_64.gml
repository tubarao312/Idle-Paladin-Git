if room != Room1 {

	var X = round(x)
	var Y = round(y)

	draw_sprite(sprite_index,image_index,X,Y)

	switch room {
		case Room2: zone = "Greenpath" break;
		case RoomCastle1: zone = "Castle" break;
		case RoomJungle1: zone = "Jungle" break;
	}
	
	draw_set_font(global.fontAlagardNormalOutlined)
	draw_text(X+5,Y+18,zone)

	draw_set_font(global.fontHopeWhite)
	draw_set_halign(fa_right)
	draw_text(X+150,Y+26,"Stage " + string(currentRun.runStages))
	draw_set_halign(fa_left)

	if alarm[0] > 0 {
		xRel = lerp(xRel,0,0.05)
	} else {
		xRel = lerp(xRel,-240,0.03)
	}

}