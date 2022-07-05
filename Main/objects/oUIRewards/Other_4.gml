if room = Room1 {

#region Stages & Kills
percentageDisplayedStages = 0;

maxStages = currentRun.runStages;
maxKills = currentRun.runKills;

displayedStages = 0
displayedKills = 0

whiteAlphaStages = 0;

#endregion

#region Gold, XP & Upgrade
percentageDisplayedCoins = 0;
maxCoins = price_create(2,532,000);
displayedCoins = price_create(1);
whiteAlphaCoins = 0;
displayCoins = false;
coinsDisplayX = -30;

percentageDisplayedXP = 0;
maxXP = floor(maxStages*power(1.015,maxStages)*maxKills);
playerStats.skillPoints += maxXP;
oUISkillTree.sfStarsUpdate = true;
displayedXP = 0;
whiteAlphaXP = 0;
displayXP = false;
XPDisplayX = -30;

percentageDisplayedUps = 0;
maxUps = ds_list_size(global.frameListNextUnlocks);
displayedUps = 0;
whiteAlphaUps = 0;
displayUps = false;
UpsDisplayX = -30;
#endregion

upgItemsDisplay1 = false;
upgItemsDisplay2 = false;



if maxStages > 0 {
	alarm[0] = 30;
	alarm[1] = 140;
	alarm[2] = 180;
	if maxUps > 0 then alarm[3] = 210;

	if upgItems {
		upgItemsDisplay1 = true;
		upgItemsDisplay2 = true;
		
		#region Distributing the points
		totalPoints = floor(maxStages*power(1.015,maxStages)*upgItemsMultiplier);
		
		item1Points = floor(totalPoints*random_range(0.55,0.65));
		item2Points = floor(totalPoints-item1Points);
		#endregion

		#region Selecting the items
		item1 = global.unlockedItemList[| floor(random_range(0,ds_list_size(global.unlockedItemList)-0.01))];
		item2 = item1;
		
		while item2 = item1 item2 = global.unlockedItemList[| floor(random_range(0,ds_list_size(global.unlockedItemList)-0.01))];
		#endregion
		
		#region Calculating how many upgrades each item gets
		item1UpgCount = min(9,floor(item1Points/(1+2*item_get_rarity(item1))));
		if item1UpgCount > 0 then upgItemsDisplay1 = true;
		item2UpgCount = min(9,floor(item2Points/(1+2*item_get_rarity(item2))));
		if item2UpgCount > 0 then upgItemsDisplay2 = true;
		#endregion
	
		
		#region Items
		item1UpgCountDisplayed = 0;
		whiteAlphaItem1 = 0;
		if upgItemsDisplay1 then alarm[4] = 240;


		item2UpgCountDisplayed = 0;
		whiteAlphaItem2 = 0;
		#endregion
	}
}

frame_unlock_all_next();
currentRun.runStages = 0;
currentRun.runKills = 0;
}