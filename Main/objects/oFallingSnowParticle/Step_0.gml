angle++;
y += yspd;
windXSpd = lerp(windXSpd, 0, 0.05);
x += windXSpd;

if (y > room_height + 10) then instance_destroy();