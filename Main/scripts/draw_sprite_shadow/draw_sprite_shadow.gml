function draw_sprite_shadow(sprite, subimg, color, dir, amount, X, Y) {
	var _x, _y, i;
	
	enum DIRS {
		UP_LEFT,
		UP_MID,
		UP_RIGHT,
		MID_LEFT,
		MID_RIGHT,
		DOWN_LEFT,
		DOWN_MID,
		DOWN_RIGHT
	}
	
	switch dir {
		case DIRS.UP_LEFT:		{ _x = -1; _y = -1; break; }
		case DIRS.UP_MID:		{ _x = 0;  _y = -1; break; }
		case DIRS.UP_RIGHT:		{ _x = 1;  _y = -1; break; }
		case DIRS.MID_LEFT:		{ _x = -1; _y = 0;  break; }
		case DIRS.MID_RIGHT:	{ _x = 1;  _y = 0;  break; }
		case DIRS.DOWN_LEFT:	{ _x = -1; _y = 1;  break; }
		case DIRS.DOWN_MID:		{ _x = 0;  _y = 1;  break; }
		case DIRS.DOWN_RIGHT:	{ _x = 1;  _y = 1;  break; }
	}
	
	gpu_set_fog(true, color, 0, 1);
	for (i = 1; i <= amount; i++) {
		draw_sprite(sprite, subimg, X+_x*i, Y+_y*i);
	}	
	gpu_set_fog(false, c_white, 0, 1);
}