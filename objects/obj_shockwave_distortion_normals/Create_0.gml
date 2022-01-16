//-----------------------------------------------------------------------------
#region SPRITE & SHADER (mandatory):
//-----------------------------------------------------------------------------
sprite			= spr_shockwave_distortion_normals_256;

shader			= shd_shockwave_distortion_normals;
u_fx_strength	= shader_get_uniform(shader, "fx_strength");
u_aspect		= shader_get_uniform(shader, "aspect");
u_aberration	= shader_get_uniform(shader, "aberration");
u_tex_waves		= shader_get_sampler_index(shader, "tex_waves");
aspect			= global.windowW/global.windowH;
tex_waves		= -1;

// wave parameters:
//wave_life		= 0.5 * game_get_speed(gamespeed_fps);	// life in seconds
wave_scale_max	= 160 / sprite_get_width(sprite);		// size in pixels in room space
enum waveparam {xx, yy, age, scale, alpha, life, strength, sprite, multiply}				// should be in unreferenced script rather

// create waves list which will hold lists for each active wave.
// those lists will be created in step event on click
// and will age and be deleted in step event as well
list_of_waves	= ds_list_create();

// prepare waves surface
srf_waves		= -1;
srf_waves_scale	= 1;
view_w			= global.windowW
view_h			= global.windowH

// turn off automatic drawing of the application surface:
application_surface_draw_enable(false);
#endregion
//-----------------------------------------------------------------------------