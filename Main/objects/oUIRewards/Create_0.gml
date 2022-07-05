
event_inherited();

xRel = -600;

#region Stages & Kills
percentageDisplayedStages = 0;

maxStages = 200;
maxKills = 3500;

displayedStages = 0
displayedKills = 0
displayedStagesPrevious = 0;
displayedKillsPrevious = 0;

whiteAlphaStages = 0;
whiteAlphaKills = 0;

sfStages = surface_create(global.windowW,global.windowH);
surface_free(sfStages);
sfKills = surface_create(global.windowW,global.windowH);
surface_free(sfKills);

#endregion

#region Gold, XP & Upgrade
percentageDisplayedCoins = 0;
maxCoins = price_create(2,532,000);
displayedCoins = price_create(1);
displayedCoinsPrevious = displayedCoins;
whiteAlphaCoins = 0;
sfCoins = surface_create(global.windowW,global.windowH);
surface_free(sfCoins);
displayCoins = false;
coinsDisplayX = -30;

percentageDisplayedXP = 0;
maxXP = 470;
displayedXP = 0;
displayedXPPrevious = displayedXP;
whiteAlphaXP = 0;
sfXP = surface_create(global.windowW,global.windowH);
surface_free(sfXP);
displayXP = false;
XPDisplayX = -30;

percentageDisplayedUps = 0;
maxUps = ds_list_size(global.frameListNextUnlocks);
displayedUps = 0;
displayedUpsPrevious = displayedUps;
whiteAlphaUps = 0;
sfUps = surface_create(global.windowW,global.windowH);
surface_free(sfUps);
displayUps = false;
UpsDisplayX = -30;
#endregion

#region Items
whiteAlphaItem1 = 0;
sfItem1 = surface_create(global.windowW,global.windowH);
surface_free(sfItem1);

whiteAlphaItem2 = 0;
sfItem2 = surface_create(global.windowW,global.windowH);
surface_free(sfItem2);
#endregion

upgItems = true;
upgItemsMultiplier = 3;

sfParts = surface_create(global.windowW,global.windowH);
surface_free(sfParts);