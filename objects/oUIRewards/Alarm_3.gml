/// @description Upgrades Display
displayUps = true;

percentageDisplayedUps = max(percentageDisplayedUps+0.02,lerp(percentageDisplayedUps,1,0.1));
if percentageDisplayedUps > 1 then percentageDisplayedUps = 1;

displayedUps = round(maxUps*percentageDisplayedUps);

if displayedUpsPrevious != displayedUps then whiteAlphaUps = 1.3-percentageDisplayedUps;

displayedUpsPrevious = displayedUps;

if percentageDisplayedUps < 1 then alarm[3] = percentageDisplayedUps*10;