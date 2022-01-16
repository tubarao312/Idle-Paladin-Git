event_inherited();

canDropGold = false;

imageSpeed = 1;
waveSpeed = random_range(2,3);
waveLength = 3;

if playerStats.coinQuantity <= 0 then instance_destroy();
else if !chance(playerStats.coinQuantity) then instance_destroy(); 

canDropGold = true;