/// @description XP Display
displayXP = true;

percentageDisplayedXP = max(percentageDisplayedXP+0.02,lerp(percentageDisplayedXP,1,0.1));
if percentageDisplayedXP > 1 then percentageDisplayedXP = 1;

displayedXP = round(maxXP*percentageDisplayedXP);

if displayedXPPrevious != displayedXP then whiteAlphaXP = 1.3-percentageDisplayedXP;

displayedXPPrevious = displayedXP

if percentageDisplayedXP < 1 then alarm[2] = percentageDisplayedXP*10;