
if instance_exists(oCamera) {
	x = oCamera.x;
	y = oCamera.y;
}

view_w			= global.windowW;
view_h			= global.windowH;

aspect			= global.windowW/global.windowH;

/// @description get clicks / wave age

// WAVE BIRTH
//-----------------------------------------------------------------------------
// create a wave on mouse-click
/*
if mouse_check_button_pressed(mb_left) {
	var new_wave = ds_list_create();
	new_wave[|waveparam.xx]		= oCursor.x;
	new_wave[|waveparam.yy]		= oCursor.y;
	new_wave[|waveparam.age]	= 0;
	new_wave[|waveparam.scale]	= 0;
	new_wave[|waveparam.alpha]	= 1;

	ds_list_add(list_of_waves, new_wave);
}
*/
// WAVE AGE:
//-----------------------------------------------------------------------------
var wave_list_size = ds_list_size(list_of_waves);
if (wave_list_size > 0) {
	var w, this_wave;
	for (w = 0; w < wave_list_size; w++) {
		this_wave = list_of_waves[|w];
		this_wave[|waveparam.age]	+= 1;
		
		if (this_wave[|waveparam.age] < this_wave[|waveparam.life]) {
			this_wave[|waveparam.scale]	= tween_cubic_out_simple(this_wave[|waveparam.age] / this_wave[|waveparam.life]) * wave_scale_max;
			this_wave[|waveparam.alpha]	= 1 - tween_quadratic_out_simple(this_wave[|waveparam.age] / this_wave[|waveparam.life]);
		} else {
			ds_list_destroy(this_wave);
			ds_list_delete(list_of_waves, w);
			w--;
			wave_list_size--;
		}
	}
}