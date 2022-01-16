/// @description Coin Display
displayCoins = true;

percentageDisplayedCoins = max(percentageDisplayedCoins+0.02,lerp(percentageDisplayedCoins,1,0.1));
if percentageDisplayedCoins > 1 then percentageDisplayedCoins = 1;

displayedCoins = price_multiply(maxCoins,percentageDisplayedCoins);

if displayedCoinsPrevious != displayedCoins then whiteAlphaCoins = 1.3-percentageDisplayedCoins;

displayedCoinsPrevious = displayedCoins;

if percentageDisplayedCoins < 1 then alarm[1] = percentageDisplayedCoins*10;