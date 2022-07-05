function draw_cline(x1,y1,x2,y2,sprite){
	var spriteWidth = sprite_get_width(sprite)
	var newWidth = sqrt(power(x1-x2,2) + power(y1-y2,2))
	
	var angle = radtodeg(arctan((y1-y2)/(x2-x1)))
	
	var xscale = newWidth/spriteWidth
	
	if x1>x2 then angle -= 180
	
	
	draw_sprite_ext(sprite,0,x1,y1,xscale,1,angle,c_white,1)

}
