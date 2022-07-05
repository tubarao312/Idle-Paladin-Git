var pushPercent = max(0,alarm[0]/pushTime);

if alarm[0] > 0 {
xSpd = ogXSpd * pushPercent;
ySpd = ogYSpd * pushPercent;
}

ogX += xSpd;
ogY += ySpd;

image_speed = imageSpeed * (1 - pushPercent);
trueWaveLength = waveLength * (1 - pushPercent);

x = ogX;
y = ogY + trueWaveLength * wave(-1,1,waveSpeed,0);

image_xscale = 1 - abs(xSpd/10);
image_yscale = 1 - abs(ySpd/10);

if pushPercent <= 0.25 and startDestroying {
	if disappearAlpha >= 0.8 then instance_destroy();
} else {
	startDestroying = false;
}