///@description Stage & Kills Display

percentageDisplayedStages = max(percentageDisplayedStages+0.02,lerp(percentageDisplayedStages,1,0.1));
if percentageDisplayedStages > 1 then percentageDisplayedStages = 1;

displayedStages = round(maxStages*percentageDisplayedStages);
displayedKills = round(maxKills*percentageDisplayedStages);

if displayedStagesPrevious != displayedStages then whiteAlphaStages = 1.3-percentageDisplayedStages;
displayedStagesPrevious = displayedStages;

if displayedKillsPrevious != displayedKills then whiteAlphaKills = 1.3-percentageDisplayedStages;
displayedKillsPrevious = displayedKills;

if percentageDisplayedStages < 1 then alarm[0] = percentageDisplayedStages*10;