#region UI / HUD / Display -----------------------------------------------------# 
global.showHUD = true;

//Display Set-up
global.createdUI = false
reset_display()
#endregion

#region Fonts ------------------------------------------------------------------#
var mapString = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.,;:?!-_~#\"'&()[]^|`/\\@º+=*% ";

// Sins Font - Rarities
global.fontSinsCommon =			font_add_sprite_ext(sFontSpriteSinsCommon,			mapString, true, -1);
global.fontSinsUncommon =		font_add_sprite_ext(sFontSpriteSinsUncommon,		mapString, true, -1);
global.fontSinsRare =			font_add_sprite_ext(sFontSpriteSinsRare,			mapString, true, -1);
global.fontSinsEpic =			font_add_sprite_ext(sFontSpriteSinsEpic,			mapString, true, -1);
global.fontSinsLegendary =		font_add_sprite_ext(sFontSpriteSinsLegendary,		mapString, true, -1);
global.fontSinsMythical =		font_add_sprite_ext(sFontSpriteSinsMythical,		mapString, true, -1);
																							 		   
// Hope Fot - Rarities																		 		  
global.fontHopeCommon =			font_add_sprite_ext(sFontSpriteHopeCommon,			mapString, true, -1);
global.fontHopeUncommon =		font_add_sprite_ext(sFontSpriteHopeUncommon,		mapString, true, -1);
global.fontHopeRare =			font_add_sprite_ext(sFontSpriteHopeRare,			mapString, true, -1);
global.fontHopeEpic =			font_add_sprite_ext(sFontSpriteHopeEpic,			mapString, true, -1);
global.fontHopeLegendary =		font_add_sprite_ext(sFontSpriteHopeLegendary,		mapString, true, -1);
global.fontHopeMythical =		font_add_sprite_ext(sFontSpriteHopeMythical,		mapString, true, -1);
																							 		   
// Mana Bar																					 		   
global.fontHopeMana =			font_add_sprite_ext(sFontSpriteHopeMana,			mapString, true, -1);
global.fontHopeManaGlowing =	font_add_sprite_ext(sFontSpriteHopeManaGlowing,		mapString, true, -1);
																							 		   
// Health Bar																				 		   
global.fontHopeHP =				font_add_sprite_ext(sFontSpriteHopeHealth,			mapString, true, -1);
global.fontHopeHPDamaged =		font_add_sprite_ext(sFontSpriteHopeHealthDamaged,	mapString, true, -1);
global.fontHopeHPHeal =			font_add_sprite_ext(sFontSpriteHopeHealthHeal,		mapString, true, -1);
																							   		 
// Carved On Paper																			   		 
global.fontHopeCarved =			font_add_sprite_ext(sFontSpriteHopeCarved,			mapString, true, -1);
																							   		 
// Damage Number																			   		 
global.fontHopeWhite =			font_add_sprite_ext(sFontSpriteHopeWhite,			mapString, true, -1);

// Inventory - Perk Icons
global.fontHopePaperDark =		font_add_sprite_ext(sFontSpriteHopePaperDark,		mapString, true, -1);
global.fontHopePaperLight =		font_add_sprite_ext(sFontSpriteHopePaperLight,		mapString, true, -1);

// Inventory - Descriptions
global.fontSinsWhite =			font_add_sprite_ext(sFontSpriteSinsWhite,			mapString, true, -1);


// Inventory - Button Fonts
global.fontSinsSortButton =		font_add_sprite_ext(sFontSpriteSinsSortButtons1,	mapString, true, -1);
global.fontSinsSortButtonGlow =	font_add_sprite_ext(sFontSpriteSinsSortButtons1Glowing,	mapString, true, -1);

global.fontHopeEquipBut	=		font_add_sprite_ext(sFontSpriteHopeEquip,			mapString, true, -1);
global.fontHopeEquipButGlow	=	font_add_sprite_ext(sFontSpriteHopeEquipGlowing,	mapString, true, -1);
global.fontHopeSalvageBut =		font_add_sprite_ext(sFontSpriteHopeSalvage,			mapString, true, -1);
global.fontHopeSalvageButGlow = font_add_sprite_ext(sFontSpriteHopeSalvageGlowing,	mapString, true, -1);
global.fontHopeUpgradeBut =		font_add_sprite_ext(sFontSpriteHopeUpgrade,			mapString, true, -1);
global.fontHopeUpgradeButGlow = font_add_sprite_ext(sFontSpriteHopeUpgradeGlowing,	mapString, true, -1);


// Stats						
global.fontSinsOrangeStats =	font_add_sprite_ext(sFontSpriteSinsOrangeStats,		mapString, true, -1);
global.fontSinsYellowStats =	font_add_sprite_ext(sFontSpriteSinsYellowStats,		mapString, true, -1);

global.fontHopeOrangeStats =	font_add_sprite_ext(sFontSpriteHopeOrangeStats,		mapString, true, -1);
global.fontHopeYellowStats =	font_add_sprite_ext(sFontSpriteHopeYellowStats,		mapString, true, -1);


#endregion

#region Misc -------------------------------------------------------------------#

//Cursor
window_set_cursor(cr_none)
cursorSkin = 0

global.cursorX = round(window_mouse_get_x()/(window_get_width()/global.windowW))
global.cursorY = round(window_mouse_get_y()/(window_get_height()/global.windowH))

startRoomTransition = false;

alarm[3] = 1;

#endregion

#region Particle System Setup --------------------------------------------------#

global.part_system_HUDAdd = part_system_create();
global.surfParticlesHUDAdd = surface_create(global.windowW, global.windowH);

global.part_system_HUD = part_system_create();
global.surfParticlesHUD = surface_create(global.windowW, global.windowH);

global.part_system_normal = part_system_create();
part_system_automatic_draw(global.part_system_normal, false);

global.part_system_normal_b = part_system_create(); // Gets drawn before the normal one
part_system_automatic_draw(global.part_system_normal_b, false);

// Environmental Particles

global.part_system_chimney_smoke = part_system_create();
part_system_automatic_draw(global.part_system_chimney_smoke, false);

global.part_system_fire_smoke = part_system_create();
part_system_automatic_draw(global.part_system_fire_smoke, false);

global.part_system_lava = part_system_create();
part_system_automatic_draw(global.part_system_lava, false);


#endregion

#region Notifications and Observers System -------------------------------------#

global.notificationList = ds_list_create();

#endregion

#region Delayed Functions ------------------------------------------------------#

global.delayedFunctions = ds_list_create();

#endregion

#region Player Stats -----------------------------------------------------------#

globalvar playerStats;
playerStats = {};

playerStats.maxHP = 1000;
playerStats.currentHP = playerStats.maxHP;
playerStats.damage = 10;
playerStats.maxMana = 8;
playerStats.currentMana = playerStats.maxMana/2;
playerStats.spd = 2;
playerStats.restingSpdPenalty = 0.2;

playerStats.get_current_speed = function() {
	return playerStats.spd 
	- (oHUDStaminaBar.resting * playerStats.restingSpdPenalty * playerStats.spd);
}


#endregion

#region Item Stats -------------------------------------------------------------#

global.statBlueprintMap = ds_map_create();
global.statBlueprintList = ds_list_create();

alarm[2] = 60;

// NEW STATS
stat_bp_create("Vitality",	STAT_COLORS.yellow, sStatIconHealth,	"", "");
stat_bp_create("Mind",		STAT_COLORS.yellow, sStatIconMana,	"", "");
stat_bp_create("Endurance", STAT_COLORS.yellow, sStatIconThorns,	"", "");

stat_bp_create("Strength",		STAT_COLORS.orange, sStatIconCrit,	"", "");
stat_bp_create("Intelligence",	STAT_COLORS.orange, sStatIconSpell,	"", "");
stat_bp_create("Dexterity",		STAT_COLORS.orange, sStatIconLuck,	"", "");

stat_bp_create("Base Damage",	STAT_COLORS.white, sStatIconDamage,	"", "");
stat_bp_create("Base Defense",	STAT_COLORS.white, sStatIconDefense,	"", "");

// OLD STATS (TO BE REMOVED)

stat_bp_create("Crit. Chance", STAT_COLORS.yellow, sStatIconCrit,	"+", "%");
stat_bp_create("Crit. Damage", STAT_COLORS.yellow, sStatIconCrit,	"+", "%");
stat_bp_create("Dodge Chance", STAT_COLORS.yellow, sStatIconLuck,	"+", "%");
stat_bp_create("Thorns", STAT_COLORS.yellow, sStatIconThorns,		"+", "%"); // Reflects thorns * base damage on to enemies who attack
stat_bp_create("Health Regeneration", STAT_COLORS.yellow, sStatIconThorns, "+", "%"); // Regens hpRegen% of max health every second

stat_bp_create("Spell Damage", STAT_COLORS.orange, sStatIconSpell,		"+", "%"); // Spells deal more damage
stat_bp_create("Spell Range", STAT_COLORS.orange, sStatIconSpell,		"+", "%"); // Spells have higher range
stat_bp_create("Spell Duration", STAT_COLORS.orange, sStatIconSpell,	"+", "%"); // Spell effects last longer
stat_bp_create("Spell Efficiency", STAT_COLORS.orange, sStatIconSpell,  "+", "%"); // Spells cost less

stat_bp_create("Maximum Mana", STAT_COLORS.orange, sStatIconMana,		"+", "");  // More max mana
stat_bp_create("Mana Gain", STAT_COLORS.orange, sStatIconMana,			"+", "%"); // More mana per hit
stat_bp_create("Mana Regeneration", STAT_COLORS.orange, sStatIconMana,	"+", "");  // Passive mana regen

#endregion

#region Inventory System -------------------------------------------------------#

global.uniqueInventoryMap = ds_map_create();

global.perkBlueprintMap = ds_map_create();
global.itemBlueprintMap = ds_map_create();
global.itemSetMap = ds_map_create();

global.itemAlphabeticList = ds_list_create(); // A list with the names of all items

enum ITEM_TYPES {
	sword, 
	shield,
	helmet,
	chestplate,
	gaunlets,
	belt,
	legwear,
	cape,
	
	size,
}

global.itemTypeNames = ["Sword", "Shield", "Helmet", "Chestplate", "Gaunlets", "Belt", "Legwear", "Cape"];



function items_update_all_alphabetic_orders() { // Run after setting up all blueprints
	ds_list_sort(global.itemAlphabeticList, false);
	
	for (var i = 0; i < ds_list_size(global.itemAlphabeticList); i++) {
		global.itemBlueprintMap[? global.itemAlphabeticList[|i]].alphabeticOrder = i;
	}
}
items_update_all_alphabetic_orders();

global.equippedItems = array_create(ITEM_TYPES.size, noone);


#region Test Item --------------------------------------------------------------------------------------------------
var sword = item_bp_create("The 'Bacalhau'", ITEM_TYPES.sword, sTestTuna, RARITY.mythical);
var belt = item_bp_create("Dante's Binding", ITEM_TYPES.belt, sTestBelt, RARITY.legendary);
var belt2 = item_bp_create("Berserker's Belt", ITEM_TYPES.belt, sTestBelt, RARITY.epic);

items_update_all_alphabetic_orders();

var set = item_set_create("The 'Tuga Set", RARITY.mythical);
item_set_add_item(set, sword);

item_set_tier_create(set, 2, "Taking damage has a 10% chance to increase damage dealt by 15% for 5 seconds.");
item_set_tier_create(set, 3, "Taking damage has a 20% chance to increase damage dealt by 25% for 6 seconds.");
item_set_tier_create(set, 4, "Taking damage has a 35% chance to increase damage dealt by 40% for 8 seconds.");

var set = item_set_create("Dante's Set", RARITY.legendary);
item_set_add_item(set, belt);

item_set_tier_create(set, 2, "Gain a small amount of mana from taking damage.");
item_set_tier_create(set, 3, "Gain a medium amount of mana from taking damage.");
item_set_tier_create(set, 4, "Gain a massive amount of mana from taking damage.");

var set = item_set_create("Berseker's Set", RARITY.epic);
item_set_add_item(set, belt2);

item_set_tier_create(set, 2, "Gain a small amount of mana from taking damage.");
item_set_tier_create(set, 3, "Gain a medium amount of mana from taking damage.");
item_set_tier_create(set, 4, "Gain a massive amount of mana from taking damage.");

global.testSword =	item_instance_create("The 'Bacalhau'", 70);
global.testBelt =	item_instance_create("Dante's Binding", 85);
global.testBelt2 =	item_instance_create("Berserker's Belt", 30);

// Fecthing the IDs of each stat
var defenseStat =	stat_get_bp("Base Defense");
var damageStat =	stat_get_bp("Base Damage");

var intStat =		stat_get_bp("Intelligence");
var dexStat =		stat_get_bp("Dexterity");
var strStat =		stat_get_bp("Strength");

var mindStat =		stat_get_bp("Mind");
var enduranceStat = stat_get_bp("Endurance");
var vitalityStat =	stat_get_bp("Vitality");

stat_add(global.testBelt, defenseStat, 103);
stat_add(global.testBelt, intStat, 12);
stat_add(global.testBelt, mindStat, 23);
stat_add(global.testBelt, enduranceStat, 4);
stat_add(global.testBelt, vitalityStat, 54);

stat_add(global.testBelt2, defenseStat, 103);
stat_add(global.testBelt2, dexStat, 12);
stat_add(global.testBelt2, enduranceStat, 23);
stat_add(global.testBelt2, strStat, 10);

stat_add(global.testSword, damageStat, 103);
stat_add(global.testSword, dexStat, 12);
stat_add(global.testSword, strStat, 23);
stat_add(global.testSword, intStat, 1);
stat_add(global.testSword, mindStat, 54);

var rampagePerk = perk_bp_create("Rampage", sPerkRampage);
perk_rank_create(rampagePerk, "Killing an enemy grants +5% bonus damage for 3 seconds");
perk_rank_create(rampagePerk, "Killing an enemy grants +7.5% bonus damage for 3.5 seconds");
perk_rank_create(rampagePerk, "Killing an enemy grants +10% bonus damage for 4 seconds");

var vampirismPerk = perk_bp_create("Vampirism", sPerkVampirism);
perk_rank_create(vampirismPerk, "Killing an enemy heals you for 2.5% of your maximum health");
perk_rank_create(vampirismPerk, "Killing an enemy heals you for 5% of your maximum health");
perk_rank_create(vampirismPerk, "Killing an enemy heals you for 7.5% of your maximum health");

var zenStatePerk = perk_bp_create("Zen State", sPerkZenState);
perk_rank_create(zenStatePerk, "Critically striking an enemy increases crit chance by 1% for 7 seconds stacking up to 10 times");
perk_rank_create(zenStatePerk, "Critically striking an enemy increases crit chance by 1.5% for 6 seconds stacking up to 10 times");
perk_rank_create(zenStatePerk, "Critically striking an enemy increases crit chance by 2% for 5 seconds stacking up to 10 times");

var headhunterPerk = perk_bp_create("Headhunter", sPerkHeadhunter);
perk_rank_create(headhunterPerk, "Grants 1% critical chance for every non-critical hit, resetting when you finally crit.");
perk_rank_create(headhunterPerk, "Grants 2% critical chance for every non-critical hit, resetting when you finally crit.");
perk_rank_create(headhunterPerk, "Grants 3% critical chance for every non-critical hit, resetting when you finally crit.");

//perk_add(global.testBelt, rampagePerk, 3);
perk_add(global.testBelt, vampirismPerk, 1);
perk_add(global.testBelt, zenStatePerk, 2);
perk_add(global.testBelt, headhunterPerk, 1);

perk_add(global.testBelt2, vampirismPerk, 1);
perk_add(global.testBelt2, zenStatePerk, 2);
perk_add(global.testBelt2, headhunterPerk, 1);

perk_add(global.testSword, vampirismPerk, 1);
perk_add(global.testSword, rampagePerk, 3);
perk_add(global.testSword, headhunterPerk, 1);
perk_add(global.testSword, zenStatePerk, 2);


#endregion -----------------------------------------------------------------------------------------------------------

global.uniqueStorage = inv_unique_create("uStorage");
inv_unique_add_item(global.uniqueStorage, global.testBelt);
inv_unique_add_item(global.uniqueStorage, global.testSword);
inv_unique_add_item(global.uniqueStorage, global.testBelt2);

var i;
for (i = 0; i < 60; i++) {
	var item = item_instance_create("Dante's Binding", i);
	inv_unique_add_item(global.uniqueStorage, item);
}

//var itemsByName = ds_priority_to_list(global.uniqueStorage.itemsByType);

#endregion

#region Resource System --------------------------------------------------------#

global.resources = {
	gold: 0,	// Resource Sink
	rubble: 0,	// Buildings & Town Upgrades
	gems: 0,	// Equipment Upgrades
}

#endregion

#region Rarity System ----------------------------------------------------------#

global.rarityArray = [];

enum RARITY {
	common,
	uncommon,
	rare,
	epic,
	legendary,
	mythical,
}

var rarity_create = function(name, ID, color, shadowColor, sinsFont, hopeFont) {
	var rarity = {};
	rarity.name = name;
	rarity.ID = ID;
	rarity.shadowColor = shadowColor;
	rarity.sinsFont = sinsFont;
	rarity.hopeFont = hopeFont;
	rarity.color = color;
	
	global.rarityArray[ID] = rarity;
	
	return rarity;
}

rarity_create("Common",		RARITY.common,		$b9a192,	$927365,	global.fontSinsCommon,		global.fontHopeCommon);	
rarity_create("Uncommon",	RARITY.uncommon,	$4b9833,	$506f1e,	global.fontSinsUncommon,	global.fontHopeUncommon);	
rarity_create("Rare",		RARITY.rare,		$dc9800,	$aa6900,	global.fontSinsRare,		global.fontHopeRare);	
rarity_create("Epic",		RARITY.epic,		$fd3fdb,	$fa097a,	global.fontSinsEpic,		global.fontHopeEpic);	
rarity_create("Legendary",	RARITY.legendary,	$1476ed,	$2445c6,	global.fontSinsLegendary,	global.fontHopeLegendary);	
rarity_create("Mythical",	RARITY.mythical,	$3024c4,	$2b1e89,	global.fontSinsMythical,	global.fontHopeMythical);

	
#endregion

// Screenfreeze
global.screenfreezeTime = 0;

// Enable HUD
global.enableHUD = true;

// Cursor Layers

/*
Explanation:
	There are multiple layers to UI that the cursor can interact with.
The idea is that the cursor should only be able to interact with the highest tier one that
is currently active.
*/

enum CURSOR_LAYERS { // Just add more enums to create new layers
	HUD,
	UI,
	size,
}

// Create array with all of the layers
global.cursorActiveLayers = array_create(CURSOR_LAYERS.size, 0);
global.cursorActiveLayers[CURSOR_LAYERS.HUD] = true;

global.cursorPriorityLayer = CURSOR_LAYERS.HUD;