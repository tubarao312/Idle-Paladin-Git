/// @description Shadow

var o = instance_create_layer(x,y,"Particles",oFireballShadow);
o.sprite_index = sprite_index
o.image_index = image_index

alarm[0] = shadowFrequency
shadowFrequency = lerp(shadowFrequency,3,0.15);