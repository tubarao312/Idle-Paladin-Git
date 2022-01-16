///draw_fadeline(x,y,width,length,angle,alpha);
///@arg x
///@arg y
///@arg width
///@arg length
///@arg angle
///@arg alpha
///@arg col
function draw_fadeline(X, Y, width, length, angle, alpha, col) {

	draw_sprite_ext(sFadelineEffect,width,X+dcos(angle)*width/2,Y-dsin(angle)*width/2,length/255,1,angle,col,alpha);

}
