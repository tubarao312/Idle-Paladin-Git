// State
if !currentPlayerStats.resting {
	sprite_index = sStaminaBarInnerCircleBright;
} else {
	sprite_index = sStaminaBarInnerCircleDark;
}

// Calculate offsets based on player coordinates, shaking, etc...
var xOffset = xPlayerOffset + round(xShakeOffset);
var yOffset = yPlayerOffset + round(yShakeOffset);

xShakeOffset = lerp(-xShakeOffset, 0, 0.3);
yShakeOffset = lerp(-yShakeOffset, 0, 0.3);

// Track the player's on-screen coordinates
x = oPlayer.x - oCamera.x + xOffset;
y = oPlayer.y - oCamera.y + yOffset;

// Calculate stamina percentage
staminaPercentage = lerp(staminaPercentage, currentPlayerStats.stamina / playerStats.maxStamina, 0.15);

// Outer Circle Animation
outerCircleImageIndex = lerp(outerCircleImageIndex, 0, 0.05);


