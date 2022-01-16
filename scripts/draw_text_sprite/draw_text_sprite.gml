///Text Background Colour
///@arg x
///@arg y
///@arg text
///@arg sprite
function draw_text_sprite(X, Y, text, sprite) {

	if !surface_exists(global.textColourSurface1) global.textColourSurface1 = surface_create(500,50);
	if !surface_exists(global.textColourSurface1Sub) global.textColourSurface1Sub = surface_create(500,50);

	surface_set_target(global.textColourSurface1Sub); //Drawing on the surface I'll subtract
	draw_clear_alpha(c_white,1);
	
	gpu_set_blendmode(bm_subtract)
	draw_text(0,0,text);
	gpu_set_blendmode(bm_normal);
	
	surface_reset_target();

	surface_set_target(global.textColourSurface1);
	
	draw_sprite(sprite,0,0,0);
	
	gpu_set_blendmode(bm_subtract)
	draw_surface(global.textColourSurface1Sub,0,0)
	gpu_set_blendmode(bm_normal);
	
	surface_reset_target();

	draw_surface(global.textColourSurface1,X,Y);
}