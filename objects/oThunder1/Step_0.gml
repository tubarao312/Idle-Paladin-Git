if image_index < 11 {
	part_emitter_region(global._part_system, global._part_emitter_3, x-10,x+10,y-sprite_get_height(sprite_index)*image_yscale+10,y+5, ps_shape_ellipse, ps_distr_linear)
	part_emitter_burst(global._part_system,global._part_emitter_3,global._part_type_19,5*image_index/11)
}

if image_index >= 7 and !effect {
	effect = true;
	shockwave(x,y,30,1.5,spr_shockwave_distortion_normals_256,random_range(0.7,1));
	screenshake(2,3);
	screenfreeze(2);
	
	hitbox = create_hitbox(x-50,y-150,100,175,oEnemyParent,120, [true,HIT_TYPE_MAGIC,playerStats.baseDamage*playerStats.spellDamage]);
	
}