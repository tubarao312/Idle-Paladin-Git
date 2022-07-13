// Coordinates by which the circle is offset to the player
xPlayerOffset = -15;
yPlayerOffset = -15;

// Coordinates to offset the circle's coords when the bar shakes
xShakeOffset = 0;
yShakeOffset = 0;

// Image Alpha
image_alpha = 1;

// Image Speed
image_speed = 0;

// Stamina
totalStamina = 100;
currentStamina = 100;
staminaPercentage = 1;

// Outer Circle
outerCircleImageIndex = 0;

// State
resting = false;

function shake(intensity, staminaCost) {
	xShakeOffset = intensity * random_sign() * random_range(11, 15);
	yShakeOffset = intensity * random_sign() * random_range(11, 15);
	currentStamina -= staminaCost;
	outerCircleImageIndex += intensity * 2.5;
	
	if currentStamina <= 0 {
		resting = true;
		currentStamina = 0;
	}
}