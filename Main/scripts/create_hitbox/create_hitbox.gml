///@arg x
///@arg y
///@arg width
///@arg height
///@arg enemy
///@arg lifetime
///@arg informationArray

function create_hitbox(X, Y, width, height, enemy, lifetime, hitInformation){
	var hitbox = instance_create_layer(X, Y, "Gamemaster", oAttackHitbox);
	hitbox.image_xscale = width;
	hitbox.image_yscale = height;
	hitbox.alarm[0] = lifetime;
	hitbox.enemy = enemy;
	hitbox.hitInformation = hitInformation;
	
	return hitbox;
}