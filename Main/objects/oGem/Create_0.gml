var spriteArray = [
sItemDropBlueBall,
sItemDropRedBall,
sItemDropGreenBall,
sItemDropOrangeBall,

sItemDropBlueLosang,
sItemDropRedLosang,
sItemDropGreenLosang,
sItemDropOrangeLosang,

sItemDropBlueEmerald,
sItemDropRedEmerald,
sItemDropGreenEmerald,
sItemDropOrangeEmerald,

sItemDropBlueSquare,
sItemDropRedSquare,
sItemDropGreenSquare,
sItemDropOrangeSquare
];

sprite_index = spriteArray[floor(random_range(0,3.99))];

event_inherited();

imageSpeed = 1;
waveSpeed = random_range(2,3);
waveLength = 3;