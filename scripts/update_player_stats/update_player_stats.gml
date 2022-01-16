function update_player_stats(){
	
	sumdb_update_all();
	
	#region Item CPS & Numbers -----------------------------------------------------#
	
	playerStats.cps = price_create(1)
	
	//---------------------------------------------------------------------------------------------------------------------------------------------------------------#
	var item = item_get_id("Sword");
	item_set_totalcps(item, price_multiply(item_get_cps(item), sumdb_get_total("Sword CPS Percent") * item_get_level(item)));
	playerStats.baseDamage = 0.75 *						item_get_level(item) * item_get_unlocked(item) * (1 + 0.01*sumdb_get_total("Sword Base Percent"));
	playerStats.cps =									item_get_totalcps(item);
	
	//---------------------------------------------------------------------------------------------------------------------------------------------------------------#
	var item = item_get_id("Chestplate");
	item_set_totalcps(item, price_multiply(item_get_cps(item), sumdb_get_total("Chestplate CPS Percent") * item_get_level(item)));
	playerStats.baseMaxHP = 100 + 5 *					item_get_level(item) * item_get_unlocked(item) * (1 + 0.01*sumdb_get_total("Chestplate Base Percent"));
	playerStats.cps =									price_add(playerStats.cps,PLUS,item_get_totalcps(item));
	
	//---------------------------------------------------------------------------------------------------------------------------------------------------------------#
	var item = item_get_id("Shield");
	item_set_totalcps(item, price_multiply(item_get_cps(item), sumdb_get_total("Shield CPS Percent") * item_get_level(item)));
	playerStats.baseDefense = 0.25 *					item_get_level(item) * item_get_unlocked(item) * (1 + 0.01*sumdb_get_total("Shield Base Percent"));
	playerStats.cps =									price_add(playerStats.cps,PLUS,item_get_totalcps(item));

	//---------------------------------------------------------------------------------------------------------------------------------------------------------------#
	var item = item_get_id("Gloves");
	item_set_totalcps(item, price_multiply(item_get_cps(item), sumdb_get_total("Gloves CPS Percent") * item_get_level(item)));
	playerStats.critChance = 0.0075 *					item_get_level(item) * item_get_unlocked(item) * (1 + 0.01*sumdb_get_total("Gloves Base Percent"));
	playerStats.cps =									price_add(playerStats.cps,PLUS,item_get_totalcps(item));

	//---------------------------------------------------------------------------------------------------------------------------------------------------------------#
	var item = item_get_id("Leggings");
	item_set_totalcps(item, price_multiply(item_get_cps(item), sumdb_get_total("Leggings CPS Percent") * item_get_level(item)));
	playerStats.hpRegen = 0.2 *							item_get_level(item) * item_get_unlocked(item) * (1 + 0.01*sumdb_get_total("Leggings Base Percent"));
	playerStats.cps =									price_add(playerStats.cps,PLUS,item_get_totalcps(item));

	//---------------------------------------------------------------------------------------------------------------------------------------------------------------#
	var item = item_get_id("Helmet");
	item_set_totalcps(item, price_multiply(item_get_cps(item), sumdb_get_total("Helmet CPS Percent") * item_get_level(item)));
	playerStats.critDamage = 1.25 + 0.0075 *			item_get_level(item) * item_get_unlocked(item) * (1 + 0.01*sumdb_get_total("Helmet Base Percent"));
	playerStats.cps =									price_add(playerStats.cps,PLUS,item_get_totalcps(item));

	//---------------------------------------------------------------------------------------------------------------------------------------------------------------#
	var item = item_get_id("Cloak");
	item_set_totalcps(item, price_multiply(item_get_cps(item), sumdb_get_total("Cloak CPS Percent") * item_get_level(item)));
	playerStats.dodgeChance = 0.25 *					item_get_level(item) * item_get_unlocked(item) * (1 + 0.01*sumdb_get_total("Cloak Base Percent"));
	playerStats.cps =									price_add(playerStats.cps,PLUS,item_get_totalcps(item));

	//---------------------------------------------------------------------------------------------------------------------------------------------------------------#
	var item = item_get_id("Amulet");
	item_set_totalcps(item, price_multiply(item_get_cps(item), sumdb_get_total("Amulet CPS Percent") * item_get_level(item)));
	playerStats.spellDamage = 1 + 0.0075 *				item_get_level(item) * item_get_unlocked(item) * (1 + 0.01*sumdb_get_total("Amulet Base Percent"));
	playerStats.cps =									price_add(playerStats.cps,PLUS,item_get_totalcps(item));
	
	//---------------------------------------------------------------------------------------------------------------------------------------------------------------#
	var item = item_get_id("Belt");
	item_set_totalcps(item, price_multiply(item_get_cps(item), sumdb_get_total("Belt CPS Percent") * item_get_level(item)));
	playerStats.bonusHealthPercentage = 1 + 0.0075 *	item_get_level(item) * item_get_unlocked(item) * (1 + 0.01*sumdb_get_total("Belt Base Percent"));
	playerStats.cps =									price_add(playerStats.cps,PLUS,item_get_totalcps(item));
	
	//---------------------------------------------------------------------------------------------------------------------------------------------------------------#
	
	#endregion
	
	//Health Total
	var hpPercent = playerStats.hp/playerStats.maxHP;
	playerStats.maxHP = playerStats.baseMaxHP * playerStats.bonusHealthPercentage;
	playerStats.hp = playerStats.maxHP * hpPercent;
	
	//Enemies Dropping Gems 
	playerStats.gemQuantity = sumdb_get_total("Gem Frequency");
	playerStats.gemCPSMulti = sumdb_get_total("Gem Amount");
	
	//Floating Coins 
	playerStats.coinQuantity = sumdb_get_total("Coin Frequency");
	playerStats.coinCPSMulti = sumdb_get_total("Coin Amount");
	
	
	//Updating Achievements
	var i, j, k;
	for (i = 0; i < ds_list_size(global.achievementList); i++) {
		var ach = global.achievementList[| i];
		var objList = ach.objectiveList;
		var scr = 0;
		
		for (j = 0; j < ds_list_size(objList); j++) {
			var obj = objList[| j];
			if obj.rank > 0 then scr += (obj.rank-1);
			
			var previousScores = 0;
			if obj.rank > 1 for (k = 0; k < obj.rank-1; k++) {
				previousScores += obj.milestones[k];
			}
			
			
			if obj.rank > 0 and obj.milestones[obj.rank-1] + previousScores - global.objectiveArray[obj.statTrack] <= 0 and obj.rank < 7 {
				obj.rank++;	
			}
		}
		
		for (j = array_length(ach.milestones)-1; j >= 0; j--) {
			if scr >= ach.milestones[j] {
				ach.rank = j+2;
				break;
			}
		}
	}
	
}