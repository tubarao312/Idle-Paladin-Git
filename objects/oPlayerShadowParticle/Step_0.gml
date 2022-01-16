alpha -= 0.035

if alpha <= 0 instance_destroy();

x += xSpd;

image_xscale = lerp(image_xscale, 1, 0.05);
image_yscale = lerp(image_yscale, 1, 0.05);