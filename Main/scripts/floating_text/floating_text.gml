///@arg x
///@arg y
///@arg text
///@arg font
function floating_text(X,Y,text,font){
	var o = instance_create_layer(X,Y,"FloatingText",oFloatingText)
	o.text = text
	o.font = font

	return o
}