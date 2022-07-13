// State
if !resting {
	currentStamina = min(currentStamina + 0.025, totalStamina);
	
	sprite_index = sStaminaBarInnerCircleBright;
	
} else {
	sprite_index = sStaminaBarInnerCircleDark;
	currentStamina = min(currentStamina + 0.5, totalStamina);

	if currentStamina >= totalStamina {
		resting = false;
		xShakeOffset = 12;
		yShakeOffset = 12;
		outerCircleImageIndex = 4;
	}
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
staminaPercentage = lerp(staminaPercentage, currentStamina / totalStamina, 0.15);

// Outer Circle Animation
outerCircleImageIndex = lerp(outerCircleImageIndex, 0, 0.05);


