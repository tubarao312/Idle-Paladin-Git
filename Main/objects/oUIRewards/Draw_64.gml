if room = Room1 and maxStages > 0 {
	xRel = lerp(xRel,0,0.08);
} else {
	xRel = lerp(xRel,-240,0.03);
}

if xRel > -220 {

part_system_automatic_draw(global._part_system_2,false)

var X = round(x);
var Y = round(y);

draw_sprite(sprite_index,image_index,X,Y);
draw_sprite(sUIRewardsBGLetters,0,X,Y);


#region Drawing Text 
if !surface_exists(sfStages) then sfStages = surface_create(global.windowW,global.windowH);
surface_set_target(sfStages);
	draw_clear_alpha(c_white,0);
	
	draw_sprite(sUIRewardsBGLetters,1,X,Y);
	
	draw_set_font(global.fontHopeWhite);
	draw_text(X+39,Y+30,displayedStages);

surface_reset_target();

gpu_set_fog(true,$9fcaf6,0,1);
draw_surface(sfStages,1,1);
draw_surface(sfStages,2,2);
gpu_set_fog(false,c_white,0,1);

draw_surface(sfStages,0,0);

if whiteAlphaStages > 0 {
	gpu_set_fog(true,c_white,0,1);
	draw_surface_ext(sfStages,0,0,1,1,0,c_white,whiteAlphaStages);
	gpu_set_fog(false,c_white,0,1);

	whiteAlphaStages = max(whiteAlphaStages-0.1,0);
}
#endregion

#region Drawing Kills Text
if !surface_exists(sfKills) then sfKills = surface_create(global.windowW,global.windowH);
surface_set_target(sfKills);
	draw_clear_alpha(c_white,0);
	
	draw_set_font(global.fontHopeWhite);

	draw_set_halign(fa_right);
	draw_text(X+108,Y+30,displayedKills);
	draw_set_halign(fa_left);
	
	draw_sprite(sUIRewardsBGLetters,2,X,Y);


surface_reset_target();

gpu_set_fog(true,$9fcaf6,0,1);
draw_surface(sfKills,1,1);
draw_surface(sfKills,2,2);
gpu_set_fog(false,c_white,0,1);

draw_surface(sfKills,0,0);

if whiteAlphaKills > 0 {
	gpu_set_fog(true,c_white,0,1);
	draw_surface_ext(sfKills,0,0,1,1,0,c_white,whiteAlphaKills);
	gpu_set_fog(false,c_white,0,1);

	whiteAlphaKills = max(whiteAlphaKills-0.1,0);
}

#endregion

#region Drawing Coins Text
if displayCoins {
	if !surface_exists(sfCoins) then sfCoins = surface_create(global.windowW,global.windowH);	
	surface_set_target(sfCoins);
		draw_clear_alpha(c_white,0);
		
		draw_sprite(sUIRewardsBGLetters,4,X+ceil(coinsDisplayX),Y);
		draw_set_font(global.fontHopeGold);
		draw_text(X+12+ceil(coinsDisplayX),Y+46,price_string(displayedCoins) + price_order(displayedCoins));

	surface_reset_target();

	gpu_set_fog(true,$9fcaf6,0,1);
	draw_surface(sfCoins,1,1);
	draw_surface(sfCoins,2,2);
	gpu_set_fog(false,c_white,0,1);

	draw_surface(sfCoins,0,0);

	if whiteAlphaCoins > 0 {
		gpu_set_fog(true,c_white,0,1);
		draw_surface_ext(sfCoins,0,0,1,1,0,c_white,whiteAlphaCoins);
		gpu_set_fog(false,c_white,0,1);

		whiteAlphaCoins = max(whiteAlphaCoins-0.1,0);
	}
	
	coinsDisplayX = lerp(coinsDisplayX,0,0.2);
}

#endregion

#region Drawing XP Text
if displayXP {
	if !surface_exists(sfXP) then sfXP = surface_create(global.windowW,global.windowH);	
	surface_set_target(sfXP);
		draw_clear_alpha(c_white,0);
		
		draw_sprite(sUIRewardsBGLetters,5,X+ceil(XPDisplayX),Y);
		draw_set_font(global.fontHopeRare);
		draw_text(X+12+ceil(XPDisplayX),Y+57,string(displayedXP) + " xp");

	surface_reset_target();

	gpu_set_fog(true,$9fcaf6,0,1);
	draw_surface(sfXP,1,1);
	draw_surface(sfXP,2,2);
	gpu_set_fog(false,c_white,0,1);

	draw_surface(sfXP,0,0);

	if whiteAlphaXP > 0 {
		gpu_set_fog(true,c_white,0,1);
		draw_surface_ext(sfXP,0,0,1,1,0,c_white,whiteAlphaXP);
		gpu_set_fog(false,c_white,0,1);

		whiteAlphaXP = max(whiteAlphaXP-0.1,0);
	}
	
	XPDisplayX = lerp(XPDisplayX,0,0.2);
}

#endregion

#region Drawing Upgrades Text
if displayUps {
	if !surface_exists(sfUps) then sfUps = surface_create(global.windowW,global.windowH);	
	surface_set_target(sfUps);
		draw_clear_alpha(c_white,0);
		
		draw_sprite(sUIRewardsBGLetters,6,X+ceil(UpsDisplayX),Y);
		draw_set_font(global.fontHopeEpic);
		draw_text(X+12+ceil(UpsDisplayX),Y+68,string(displayedUps) + " upgrades");

	surface_reset_target();

	gpu_set_fog(true,$9fcaf6,0,1);
	draw_surface(sfUps,1,1);
	draw_surface(sfUps,2,2);
	gpu_set_fog(false,c_white,0,1);

	draw_surface(sfUps,0,0);

	if whiteAlphaUps > 0 {
		gpu_set_fog(true,c_white,0,1);
		draw_surface_ext(sfUps,0,0,1,1,0,c_white,whiteAlphaUps);
		gpu_set_fog(false,c_white,0,1);

		whiteAlphaUps = max(whiteAlphaUps-0.1,0);
	}
	
	UpsDisplayX = lerp(UpsDisplayX,0,0.2);
}

#endregion

#region Drawing Item Level Ups
#region Item 2
if upgItemsDisplay2 and item2UpgCount > 0 {
	if !surface_exists(sfItem2) then sfItem2 = surface_create(global.windowW,global.windowH);	
	surface_set_target(sfItem2);
		draw_clear_alpha(c_white,0);
		
		if item2UpgCountDisplayed > 0 {
			draw_sprite(item_get_sprite(item2),item_get_rarity(item2),X+63,Y+37);
			draw_sprite(sUIRewardsNumbers,item2UpgCountDisplayed,X+94,Y+80);
		} else {
			draw_sprite(sUIShopQuestionIcons,0,X+63,Y+37);
		}
		
	surface_reset_target();

	draw_surface(sfItem2,0,0);

	if whiteAlphaItem2 > 0 {
		gpu_set_fog(true,c_white,0,1);
		draw_surface_ext(sfItem2,0,0,1,1,0,c_white,whiteAlphaItem2);
		gpu_set_fog(false,c_white,0,1);

		whiteAlphaItem2 = max(whiteAlphaItem2-0.1,0);
	}
}
#endregion

#region Item 1
if upgItemsDisplay1 and item1UpgCount > 0 {
	if !surface_exists(sfItem1) then sfItem1 = surface_create(global.windowW,global.windowH);	
	surface_set_target(sfItem1);
		draw_clear_alpha(c_white,0);
		
		if item1UpgCountDisplayed > 0 {
			draw_sprite(item_get_sprite(item1),item_get_rarity(item1),X+93,Y+37);
			draw_sprite(sUIRewardsNumbers,item1UpgCountDisplayed,X+124,Y+80);
		} else {
			draw_sprite(sUIShopQuestionIcons,0,X+93,Y+37);
		}
		
	surface_reset_target();

	draw_surface(sfItem1,0,0);

	if whiteAlphaItem1 > 0 {
		gpu_set_fog(true,c_white,0,1);
		draw_surface_ext(sfItem1,0,0,1,1,0,c_white,whiteAlphaItem1);
		gpu_set_fog(false,c_white,0,1);

		whiteAlphaItem1 = max(whiteAlphaItem1-0.1,0);
	}
}

#endregion

#endregion

draw_sprite(sUIRewardsBGLetters,3,X,Y);

if !surface_exists(sfParts) then sfParts = surface_create(global.windowW,global.windowH);
surface_set_target(sfParts);
draw_clear_alpha(c_white,0);
part_system_drawit(global._part_system_2);
surface_reset_target();

gpu_set_blendmode(bm_add);
draw_surface(sfParts,0,0);
gpu_set_blendmode(bm_normal);

part_system_automatic_draw(global._part_system_2,true)
}