event_inherited();

ogY = y;
page = 1;
maxPages = 10;
renewShownList = true;

lastHoveredUpgrade = global.frameListBuyable[| 0];
boughtUpgrade = 0;
confirmPercent = 0;

sf = surface_create(global.windowW,global.windowH);
surface_free(sf);

shake = array_create(maxPages*16,0);

alarm[0] = 60;

updatePrices = false;
showUpPrev = false;