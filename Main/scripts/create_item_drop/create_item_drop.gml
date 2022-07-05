///@arg object
///@arg X
///@arg Y
///@arg xSpd
///@arg ySpd
///@arg pushTime
///@arg imageSpeed
///@arg magnetic?
///@arg waveSpeed
///@arg waveLength

function create_item_drop(object,X,Y,xSpd,ySpd,pushTime,imageSpeed,magnetic,waveSpeed,waveLength) {
	var o = instance_create_layer(X,Y,"Coins",object);
	o.ogXSpd = xSpd;
	o.ogYSpd = ySpd;
	o.alarm[0] = pushTime;
	o.pushTime = pushTime;
	o.imageSpeed = imageSpeed;
	o.magnetic = magnetic;
	o.waveSpeed = waveSpeed;
	o.waveLength = waveLength;
	
	return o;
}