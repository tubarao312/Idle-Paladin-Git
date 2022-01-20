y = 0;

#region VFX

function vfx_pop(X, Y) {
	instance_create_depth(X, Y, depth-1, oNewCatchParticle);
	part_emitter_region(global.part_system_HUD, emitter1, X + 2, X - 2, Y + 2, Y - 2, ps_shape_ellipse, ps_distr_linear);
	part_emitter_burst(global.part_system_HUD, emitter1, particlesNewCatch, 10);
}

#endregion

#region Surfaces ----------------------------------------------------------------------

// All
surFinal =						surface_create(global.windowW, global.windowH);

// Browsing
surItemGrid =					surface_create(global.windowW, global.windowH);
surItemGridShadowCasters =		surface_create(global.windowW, global.windowH);
surUpperFrame =					surface_create(global.windowW, global.windowH);
surUpperFrameShadowCasters =	surface_create(global.windowW, global.windowH);
surFinalBrowse =				surface_create(global.windowW, global.windowH);

// Inspect
surFinalInspect =				surface_create(global.windowW, global.windowH);
surBackground =					surface_create(global.windowW, global.windowH);
surLowerButtons =				surface_create(global.windowW, global.windowH);
surItemDisplay =				surface_create(global.windowW, global.windowH);
surCheckForDisappearences =		surface_create(1, 1);

#endregion ----------------------------------------------------------------------------

#region Set Sprites
progressionCircleSprites = 
	[sUIInventorySetProgressCirclesCommon,
	sUIInventorySetProgressCirclesUncommon,
	sUIInventorySetProgressCirclesRare,
	sUIInventorySetProgressCirclesEpic,
	sUIInventorySetProgressCirclesLegendary,
	sUIInventorySetProgressCirclesMythical];
#endregion

#region State Machine Enums -----------------------------------------------------------

enum INVENTORY_UI_STATE { // General
	browsing,
	inspecting,
	
}

inventoryUIState = INVENTORY_UI_STATE.browsing;

enum INSPECT_UI_STATE { // Inspecting 
	standard,
	inspectingSet,
	
	inspectingPerk0,
	inspectingPerk1,
	inspectingPerk2,
	inspectingPerk3,
	
}

inspectUIState = INSPECT_UI_STATE.standard;

enum BROWSE_UI_STATE { // Browsing
	standard,
}

#endregion ----------------------------------------------------------------------------

#region Item Grid Setup----------------------------------------------------------------

itemGrid = {
	// Item Rows
	totalItemRows: 0,
	currentItemRow: 0,
	previousItemRow: 0,
	targetItemRow: 0,
	
	// Coordinates for items being drawn
	scrollY: 0,
	scrollYTarget: 0,
	
	// Zooming in Effect
	zoomCardScale: 0,
	
	// Whether cards are going up or down
	goingUp: true,
	
	// Shown Item List
	shownItemList: noone,
};

itemGrid.step = function() { // Logic + Drawing
	// Controls
	if mouse_wheel_up() then itemGrid.scrollUp();
	else if mouse_wheel_down() then itemGrid.scrollDown();
	
	// Following the Target Item Row
	itemGrid.targetItemRow = clamp(itemGrid.targetItemRow, 0, max(0, itemGrid.totalItemRows - 3));
	itemGrid.scrollYTarget = itemGrid.targetItemRow * 50;
	itemGrid.scrollY = lerp(itemGrid.scrollY, itemGrid.scrollYTarget, 0.2);
	itemGrid.currentItemRow = round(itemGrid.scrollY / 50);
	
	if itemGrid.previousItemRow != itemGrid.currentItemRow {
		itemGrid.goingUp = (itemGrid.previousItemRow > itemGrid.currentItemRow);
		itemGrid.zoomCardScale = !itemGrid.goingUp;
		alarm[3] = 15;
		alarm[4] = 15;
		
		itemGrid.previousItemRow = itemGrid.currentItemRow;
	}
	
	if alarm[3] <= 0 then itemGrid.zoomCardScale = lerp(itemGrid.zoomCardScale, 0, 0.2);
	else itemGrid.zoomCardScale = lerp(itemGrid.zoomCardScale, itemGrid.goingUp, 0.25 - !itemGrid.goingUp*0.15);
	
	// Go through all item cards and draw / process them
	var i;
	for (i = max(0, itemGrid.currentItemRow*6 - 6); i < min(itemGrid.currentItemRow*6 + 24, ds_list_size(itemGrid.shownItemList)); i++) {
		var item = itemGrid.shownItemList[|i];
		var horizontalPos = i % 6;
		var verticalPos = floor(i / 6);
		
		if (verticalPos - itemGrid.currentItemRow >= -1 and verticalPos - itemGrid.currentItemRow <= 5) {
			var X = 105 + horizontalPos*43 + x;
			var Y = 70 + (verticalPos - itemGrid.currentItemRow + !itemGrid.goingUp)*50 - itemGrid.scrollY % 50 + y;
			
			if (Y > 65 + y) and (Y < 175 + y) step_item_card(item, X, Y);
			else {
				var cardScale; 
				if (Y < 65 + y) then cardScale = itemGrid.zoomCardScale;
				else cardScale = 1;
				
				draw_item_card(item, false, X, Y, cardScale);
			}
			
			draw_set_font(global.fontHopeCommon);
		}
	}
}

itemGrid.scrollUp = function() { // Scroll Up
	itemGrid.targetItemRow --;
}

itemGrid.scrollDown = function() { // Scroll Down
	itemGrid.targetItemRow ++;
}

itemGrid.reset = function() { // Resets Item Grid to Baseline
	itemGrid.totalItemRows = ceil(ds_list_size(itemGrid.shownItemList) / 6);
	itemGrid.currentItemRow = 0;
	itemGrid.previousItemRow = 0;
	itemGrid.targetItemRow = 0;

	itemGrid.scrollYTarget = 0;

	itemGrid.zoomCardScale = 0;

	itemGrid.goingUp = true;
}

#endregion ----------------------------------------------------------------------------

#region Scroll Bar Setup --------------------------------------------------------------

enum SCROLL_BAR_STATE {
		// Being controlled by the item grid
		standard,
		standardStart,
		standardFinish,
		
		// Controlling the item grid
		dragged,
		draggedStart,
		draggedFinish,
		
		// Not active
		inactive,
		inactiveStart,
		inactiveFinish,
}

scrollBar = {
	// Where the bar is initiallity drawn at
	baseY: 60, 
	baseX: 368,
	
	// Where the bar can go to
	scrollY: 0,
	scrollMaxY: 106,
	
	// State Machine
	state: SCROLL_BAR_STATE.standardStart,
	
	// Percentage (From 0 to 1)
	scrollPercentage: 0,
	
	// Sprite Index
	sprite_index: sUIInventoryScrollBarStandard,
	image_index: 0,
	
	// Tracking cursor movements
	cursorYPrevious: 0,
};

scrollBar.draw = function() { // Draws Itself
	draw_sprite(scrollBar.sprite_index, scrollBar.image_index, scrollBar.baseX + x, scrollBar.baseY + scrollBar.scrollY + y);
}

scrollBar.step = function() { // Step Function
	// Calculating the hitbox for the scrollbar
	var spriteW = sprite_get_width(scrollBar.sprite_index);
	var spriteH = sprite_get_height(scrollBar.sprite_index);
	
	var X1 = scrollBar.baseX + spriteW/2 + 1 + x;
	var X2 = scrollBar.baseX - spriteW/2 - 1 + x;
	
	var Y1 = scrollBar.baseY + scrollBar.scrollY + spriteH/2 + 1 + y;
	var Y2 = scrollBar.baseY + scrollBar.scrollY - spriteH/2 - 1 + y;
	
	// Possible Inputs
	var hovered = cursor_in_box(X1, Y1, X2, Y2);
	var pressed = hovered and oPlayer.inputs.mbLeft[PRESSED];
	var released = oPlayer.inputs.mbLeft[RELEASED];
	
	// State Machine
	var generalState = floor(scrollBar.state/3) * 3;
	var specificState = scrollBar.state;
	
	switch generalState {
		case SCROLL_BAR_STATE.standard: { // Being controlled by the item grid
			if specificState == SCROLL_BAR_STATE.standardStart { // Entering state
				scrollBar.sprite_index = sUIInventoryScrollBarStandard;
				scrollBar.state = SCROLL_BAR_STATE.standard;
			}
			
			// Making the bar follow the target item row
			var percent = scrollBar.scrollPercentage;
			
			percent = lerp(percent, itemGrid.targetItemRow / max(1, (itemGrid.totalItemRows - 3)), 0.2);
			percent = clamp(percent, 0, 1);
			scrollBar.scrollY = percent * scrollBar.scrollMaxY;
			
			scrollBar.scrollPercentage = percent;
		
			// Entering Dragged State
			if hovered and pressed then scrollBar.state = SCROLL_BAR_STATE.draggedStart;
		break; }
		case SCROLL_BAR_STATE.dragged: { // Controlling the item grid, controlled by cursor
			if specificState == SCROLL_BAR_STATE.draggedStart { // Entering state
				scrollBar.sprite_index = sUIInventoryScrollBarDragged;
				scrollBar.state = SCROLL_BAR_STATE.dragged;
				scrollBar.cursorYPrevious = global.cursorY;
				
			}
			
			// Making the bar follow the cursor
			scrollBar.scrollY += (global.cursorY - scrollBar.cursorYPrevious);
			scrollBar.scrollY = clamp(scrollBar.scrollY, 0, 106);
			scrollBar.scrollPercentage = scrollBar.scrollY / scrollBar.scrollMaxY; // Percentage is updated
			
			// Tracking previous cursor position
			scrollBar.cursorYPrevious = global.cursorY;
			
			// Making the item grid follow the bar
			itemGrid.targetItemRow = round(scrollBar.scrollPercentage * itemGrid.totalItemRows); // Target Item Row follows percentage
		
			// Leaving the Dragged State
			if released then scrollBar.state = SCROLL_BAR_STATE.standardStart;
		break; }
		case SCROLL_BAR_STATE.inactive: { // Not being used, can't be interacted with
			if specificState == SCROLL_BAR_STATE.inactiveStart {
				scrollBar.sprite_index = sUIInventoryScrollBarStandard;
				scrollBar.state = SCROLL_BAR_STATE.inactive;
			}
		
		break; }
		
	}
	
	// Image Index
	scrollBar.image_index = (hovered or generalState == SCROLL_BAR_STATE.dragged);
	if hovered or generalState == SCROLL_BAR_STATE.dragged then cursor_skin(1);
	
}

scrollBar.reset = function () { // Resets Variables and state
	scrollBar.state = SCROLL_BAR_STATE.standardStart;
	scrollBar.scrollY = 0;
}

#endregion ---------------------------------------------------------------

#region Button Shenanigans

function button_create(normalSprite, glowingSprite, normalFont, glowingFont, text, textOffsetX, textOffsetY) {
	var button = {};
	button.normalSprite = normalSprite;
	button.glowingSprite = glowingSprite;
	button.normalFont = normalFont;
	button.glowingFont = glowingFont;
	button.text = text;
	button.textOffsetX = textOffsetX;
	button.textOffsetY = textOffsetY;
	
	// For Drawing
	button.sprite_index = normalSprite;
	button.image_index = 0;
	button.x = 0;
	button.y = 0;
	button.image_xscale = 1;
	button.image_yscale = 1;
	button.image_alpha = 1;
	
	// Interaction
	button.hovered = false;
	button.pressed = false;
	
	// Knowing if it's down or up
	button.pressedTimer = 0;
	button.pressedCooldown = 30;
	
	// For Hitbox
	button.width = sprite_get_width(button.normalSprite);
	button.height = sprite_get_height(button.normalSprite);
	
	return button;
}

function step_button(button) {
	// Checking if it's being hovered
	var x1 = button.x - button.width  / 2 - 1;
	var x2 = button.x + button.width  / 2 + 1;
	var y1 = button.y - button.height / 2 - 1;
	var y2 = button.y + button.height / 2 + 1;
	
	button.hovered = cursor_in_box(x1, y1, x2, y2);
	
	// Checking if it's being pressed
	button.pressed = button.hovered and !button.pressedTimer and oPlayer.inputs.mbLeft[PRESSED];
	if button.pressed then button.pressedTimer = button.pressedCooldown;
	
	// If it's being hovered, glow
	if button.hovered {
		button.sprite_index = button.glowingSprite;
		if button.glowingFont != noone then draw_set_font(button.glowingFont);
	} else {
		button.sprite_index = button.normalSprite;
		if button.normalFont != noone then draw_set_font(button.normalFont);
	}
	
	// If button is pressed, go down
	if button.pressedTimer > 0 { 
		button.pressedTimer --;
		button.image_index = 1;
	} else { // Else, it goes up
		button.image_index = 0;
	}
	
	// Changing cursor skin
	if button.hovered and !button.pressedTimer then cursor_skin(1);
	
	// Drawing the button
	draw_sprite_ext(button.sprite_index, button.image_index, button.x, button.y, button.image_xscale, button.image_yscale, 0, c_white, 1);

	// Drawing Text
	if button.text != noone {
		draw_set_halign(fa_middle);
		draw_text(button.x + button.textOffsetX, button.y + button.textOffsetY + (button.pressedTimer > 0)*2, button.text);
		draw_set_halign(fa_left);
	}
}

// Exit Button
butExit = button_create(sUIInventoryExitButton, sUIInventoryExitButtonGlowing, noone, noone, noone, 0, 0);

// Equip Button
butEquip = button_create(sUIInventoryEquipButton, sUIInventoryEquipButtonGlowing, 
				global.fontHopeEquipBut, global.fontHopeEquipButGlow, 
				"Equip", 0, -4);

// Upgrade Button
butUpgrade = button_create(sUIInventoryUpgradeButton, sUIInventoryUpgradeButtonGlowing,
				global.fontHopeUpgradeBut, global.fontHopeUpgradeButGlow, 
				"Upgrade", -1, -4);
				
// Salvage Button
butSalvage = button_create(sUIInventorySalvageButton, sUIInventorySalvageButtonGlowing,
				global.fontHopeSalvageBut, global.fontHopeSalvageButGlow, 
				"Salvage", -1, -4);

butLock = button_create(sUIInventoryLockButtonUnlocked, sUIInventoryLockButtonUnlockedGlowing, noone, noone, noone, 0, 0);
butBack = button_create(sUIInventoryBackButton, sUIInventoryBackButtonGlowing, noone, noone, noone, 0, 0);

inspectLowerButtons = [butEquip, butUpgrade, butSalvage, butLock, butBack];

function inspect_buttons_reset() {
	var i;
	for (i = 0; i < array_length(inspectLowerButtons); i++) {
		var button = inspectLowerButtons[i];
		button.y = 230 + y;
		button.ySpd = 0;
		button.pressedTimer = 0;
		button.pressed = false;
		button.hovered = false;
		button.shouldDisappear = true;
		
		alarm[1] = 30;
	}
}
inspect_buttons_reset();

// Sorting ------------
var normalFont = global.fontSinsSortButton;
var glowingFont = global.fontSinsSortButtonGlow;

// First Option
butSort1 = button_create(sUIInventorySortButton1, sUIInventorySortButton1Glowing,
				normalFont, glowingFont, "All", 0, -9);							
butSort1.pressedCooldown = 10;
butSort1.optionSelected = 0; // Selected Filter Within Array Below
butSort1.textOptions = ["All", "New", "Favorite"];

// Second Option
butSort2 = button_create(sUIInventorySortButton2, sUIInventorySortButton2Glowing,
				normalFont, glowingFont, "Items", 0, -9);
butSort2.pressedCooldown = 10;
butSort2.optionSelected = 0; // Selected Filter Within Array Below
butSort2.textOptions = ["Items", "Swords", "Shields", "Helmets", "Chestplates", "Gaunlets", "Belts", "Legwear", "Capes"];

// Third Option
butSort3 = button_create(sUIInventorySortButton3, sUIInventorySortButton3Glowing,
				normalFont, glowingFont, "By Date", 0, -9);
butSort3.pressedCooldown = 10;
butSort3.optionSelected = 0; // Selected Filter Within Array Below
butSort3.textOptions = ["By Date", "A-Z", "By Level", "By Rarity"];

function sort_buttons_reset() {
	butSort1.optionSelected = 0;
	butSort2.optionSelected = 0;
	butSort3.optionSelected = 0;
}

function sort_buttons_generate_new_list() {
	var shownList;
	var i;
			
	switch butSort3.optionSelected { // Order
		case 0: shownList = ds_list_create(); ds_list_copy(shownList, global.uniqueStorage.items); break; // By Date
		case 1: shownList = ds_priority_to_list(global.uniqueStorage.itemsByName); break; // A-Z
		case 2: shownList = ds_priority_to_list(global.uniqueStorage.itemsByLevel); break; // By Level
		case 3: shownList = ds_priority_to_list(global.uniqueStorage.itemsByRarity); break; // By Rarity
	}
	
	if (butSort2.optionSelected != 0) { // Selected Item Type
		for (i = ds_list_size(shownList)-1; i >= 0; i--) {
			var item = shownList[|i];
			if (item.bp.type + 1) != butSort2.optionSelected then ds_list_delete(shownList, i);
		}
	}
	
	if (butSort1.optionSelected != 0) { // All, New, Favourite
		for (i = ds_list_size(shownList)-1; i >= 0; i--) {
			var item = shownList[|i];
			
			switch butSort1.optionSelected {
				case 1: if !item.newlyAcquired then ds_list_delete(shownList, i); break; // New
				case 2: if !item.locked then ds_list_delete(shownList, i); break; // Locked
			}
		}
	}
	
	itemGrid.shownItemList = shownList;
	
	itemGrid.reset();
	scrollBar.reset();
}

sort_buttons_generate_new_list();

#endregion

#region Perk Icons

function perk_icon_create(sprite) {
	var icon = {};
	icon.sprite = sprite;
	icon.innerSprite = noone;
	icon.rank = 0;

	// For Drawing
	icon.sprite_index = sprite;
	icon.image_index = 0;
	icon.x = 0;
	icon.y = 0;
	icon.image_xscale = 1;
	icon.image_yscale = 1;
	icon.image_alpha = 1;
	
	// Interaction
	icon.hovered = false;
	icon.hoveredPrev = false;
	
	// For Hitbox
	icon.width = sprite_get_width(icon.sprite);
	icon.height = sprite_get_height(icon.sprite);
	
	// Image Scale For Juice
	icon.scaleSpeed = 0;
	icon.scale = 0;
	
	return icon;
}

function step_perk_icon(icon) {
	// Checking if it's being hovered
	var x1 = icon.x - icon.width  / 2 - 2;
	var x2 = icon.x + icon.width  / 2 + 1.95;
	var y1 = icon.y - icon.height / 2 - 1.95;
	var y2 = icon.y + icon.height / 2 + 1.95;
	
	icon.hoveredPrev = icon.hovered;
	icon.hovered = cursor_in_box(x1, y1, x2, y2);
	
	// If it's being hovered, glow
	icon.image_index = icon.hovered;

	if icon.hovered then cursor_skin(2);
	
	// Image Scale Approaching
	icon.scaleSpeed = lerp(icon.scaleSpeed, (1 - icon.scale) / 2, 0.2);
	icon.scale += icon.scaleSpeed;
	icon.image_xscale = min(icon.scale, 1.15);
	icon.image_yscale = min(icon.scale, 1.15);
	
	if icon.scale >= 0.15 {
		// Drawing the button
		draw_sprite_ext(icon.sprite_index, icon.image_index, icon.x, icon.y - icon.hovered, icon.image_xscale, icon.image_yscale, 0, c_white, 1);
		if icon.innerSprite != noone { // Drawing the perk symbol
			var shadowColors = [ $4a6fbf, $699ce6];
		
			gpu_set_fog(true, shadowColors[icon.hovered], 0, 1); // Shadows
			draw_sprite_ext(icon.innerSprite, icon.image_index, icon.x + 1, icon.y + 1 - icon.hovered, icon.image_xscale, icon.image_yscale, 0, c_white, 1);
			gpu_set_fog(false, c_white, 0, 1);
		
			draw_sprite_ext(icon.innerSprite, icon.image_index, icon.x, icon.y - icon.hovered, icon.image_xscale, icon.image_yscale, 0, c_white, 1);
		}
	
		// Drawing Rank
		if icon.rank != 0 {
			var fonts = [global.fontHopePaperDark, global.fontHopePaperLight];
		
			draw_set_font(fonts[icon.hovered]);
		
			draw_set_halign(fa_right);
			draw_text(icon.x + (icon.width/2 - 1 + icon.hovered)*icon.image_xscale, icon.y + (icon.height/2 - 7)*icon.image_yscale, icon.rank);
			draw_set_halign(fa_left);
		}
	}
	
}

function perk_scale_reset(icon) {
	icon.scale = 0;
	icon.scaleSpeed = 0;
	icon.image_xscale = 0;
	icon.image_yscale = 0;
}

function inspect_perks_reset() {
	var i;
	for (i = 0; i < array_length(perkIcon); i++) {
		var icon = perkIcon[i];
		icon.scale = 0;
	}
}

perkIcon[0] = perk_icon_create(sUIInventoryPerkFrame1);
perkIcon[1] = perk_icon_create(sUIInventoryPerkFrame2);
perkIcon[2] = perk_icon_create(sUIInventoryPerkFrame3);
perkIcon[3] = perk_icon_create(sUIInventoryPerkFrame4);

function step_all_perk_icons(item) {
	var perkList = item.perkList;
	var activePerkAmount = ds_list_size(item.perkList);
	
	switch activePerkAmount { // Switching Icon Positions
		case 1: { // 1 Active Perks
			perkIcon[0].x = 266 + x;
			perkIcon[0].y = 40 + y;
		break; }
		case 2: { // 2 Active Perks
			perkIcon[0].x = 248 + x;
			perkIcon[0].y = 40 + y;
			
			perkIcon[1].x = 284 + x;
			perkIcon[1].y = 40 + y;
		break; }
		case 3: { // 3 Active Perks
			perkIcon[0].x = 230 + x;
			perkIcon[0].y = 40 + y;
			
			perkIcon[1].x = 266 + x;
			perkIcon[1].y = 40 + y;
			
			perkIcon[2].x = 302 + x;
			perkIcon[2].y = 40 + y;
		break; }
		case 4: { // 4 Active Perks
			perkIcon[0].x = 212 + x;
			perkIcon[0].y = 40 + y;
			
			perkIcon[1].x = 248 + x;
			perkIcon[1].y = 40 + y;
			
			perkIcon[2].x = 284 + x;
			perkIcon[2].y = 40 + y;
			
			perkIcon[3].x = 320 + x;
			perkIcon[3].y = 40 + y;
			
			
		break; }
	}
	
	var i;
	for (i = 0; i < activePerkAmount; i++) { // Assigning perk sprites and ranks
		if (i < ds_list_size(perkList)) {
			perkIcon[i].innerSprite = perkList[|i].bp.sprite; // Changing Perk Sprite
			perkIcon[i].rank = perkList[|i].rank; // Changing Perk Level
		}
		
		step_perk_icon(perkIcon[i]);
	}
}

#endregion

#region Stat Text

function stat_draw_name(X, Y, stat) {
	var sinsFonts = [global.fontSinsCommon, global.fontSinsYellowStats, global.fontSinsOrangeStats];

	draw_sprite(stat.bp.iconSprite, 0, X, Y);
	
	draw_set_font(sinsFonts[stat.bp.statCol]);
	draw_text(X + 10, Y, stat.bp.name);
}

function stat_draw_quantity(X, Y, stat) {
	var hopeFonts = [global.fontHopeCommon, global.fontHopeYellowStats, global.fontHopeOrangeStats];
	var text = "";
	
	text += stat.bp.prefixStr;
	text += string(stat.quantity);
	text += stat.bp.sufixStr;
	
	draw_set_font(hopeFonts[stat.bp.statCol]);
	draw_text(X, Y, text);
}

#endregion

#region Lower Frame

lowerFrameState = INSPECT_UI_STATE.standard;

// Standard Lower Frame ------------------------------------------------------------------

surLowerFrameStandardFinal =			surface_create(global.windowW, global.windowH);
surLowerFrameStandardShadowCasters =	surface_create(global.windowW, global.windowH);

function draw_lower_frame_standard(item) {
	var set = item.bp.set;
	
	// Things that cast shadows
	if !surface_exists(surLowerFrameStandardShadowCasters) then surLowerFrameStandardShadowCasters = surface_create(global.windowW, global.windowH);
	surface_set_target(surLowerFrameStandardShadowCasters) {
		draw_clear_alpha(c_white, 0);
	
		// Set Title
		draw_set_font(global.rarityArray[set.baseRarity].hopeFont);
		draw_set_halign(fa_middle);
		draw_text(137, 83, set.name);
	
	
		draw_sprite(progressionCircleSprites[set.baseRarity], item_set_get_character_tier(set), 106, 105);
	
		// Set Pieces
		draw_set_halign(fa_left);
	
		for (var i = 0; i < 3; i++) {
			if (i < ds_list_size(set.tierList) and i < item_set_get_character_tier(set)) {
				var tier = set.tierList[|i];
			
				var str = string(tier.piecesRequired) + " piece";
				if tier.piecesRequired > 1 then str += "s";
			
				draw_text(120, 106 + i * 20, str);
			}
		}
	
		// Stats
		if ds_list_size(item.statList) > 0 {
			var statNameX = 202;
			var statQuantX = 332;
		
			stat_draw_name(statNameX , 77, item.statList[|0]); // First Stat
			draw_set_halign(fa_right);
			stat_draw_quantity(statQuantX , 83, item.statList[|0]);
	
			var i;
			for (i = 1; i < ds_list_size(item.statList); i++) { // Rest of the stats
			
				draw_set_halign(fa_left);
				stat_draw_name(statNameX, (i*14) + 85, item.statList[|i]);
	
				draw_set_halign(fa_right);
				stat_draw_quantity(statQuantX, (i*14) + 91, item.statList[|i]);
			}
		}
	
		surface_reset_target();
	}

	// Drawing the shadow casters, their shadows and background drawings
	if !surface_exists(surLowerFrameStandardFinal) then surLowerFrameStandardFinal = surface_create(global.windowW, global.windowH);
	surface_set_target(surLowerFrameStandardFinal) {
		draw_clear_alpha(c_white, 0);
	
		// Small division in the middle of the lower frame
		draw_sprite_ext(sUIInventoryBgFrame2Line, 0, 189, 80, 1, 1, 0, c_white, 1);

		// Separators
		draw_sprite(sUIInventoryBgFrame2Separator1, 0, 94,	96);
		draw_sprite(sUIInventoryBgFrame2Separator2, 0, 198, 96);
	
		// Carved Set Stuff
		draw_sprite(sUIInventoryCarvedSetPath, ds_list_size(set.tierList), 106, 105);
		
		draw_set_font(global.fontHopeCarved);
		draw_set_halign(fa_left);
		for (var i = 0; i < 3; i++) {
			if (i < ds_list_size(set.tierList)) {
				var tier = set.tierList[|i];
			
				var str = string(tier.piecesRequired) + " piece";
				if tier.piecesRequired > 1 then str += "s";
			
				draw_text(120, 106 + i * 20, str);
			}
		}
	
		// Stat Underlines
		if ds_list_size(item.statList) > 0 {
			var statNameX = 203;
		
			draw_sprite(sUIInventoryStatUnderline, 0, statNameX, 90);
	
			var i;
			for (i = 1; i < ds_list_size(item.statList); i++) { // Rest of the stats
				draw_sprite(sUIInventoryStatUnderline, 0, statNameX, (i*14) + 97);
			}
		}
	
		// Shadow Casting Text
		gpu_set_fog(true, $699ce6, 0, 1);
		draw_surface(surLowerFrameStandardShadowCasters, 1, 1);
		draw_surface(surLowerFrameStandardShadowCasters, 2, 2);
		gpu_set_fog(false, c_white, 0, 1);
	
		draw_surface(surLowerFrameStandardShadowCasters, 0, 0);

	surface_reset_target(); }
	
	
}

function lower_frame_state_submit_standard(item) {
	draw_lower_frame_standard(item);
	lower_frame_submit_surface(surLowerFrameStandardFinal);
}

// Set Inspection Lower Frame ------------------------------------------------------------

surLowerFrameSetFinal =					surface_create(global.windowW, global.windowH);
surLowerFrameSetShadowCasters =			surface_create(global.windowW, global.windowH);

function draw_lower_frame_set_inspect(item) {
	var set = item.bp.set;
	var setRank = item_set_get_character_tier(set);
	
	// Things that cast shadows
	if !surface_exists(surLowerFrameSetShadowCasters) then surLowerFrameSetShadowCasters = surface_create(global.windowW, global.windowH);
	surface_set_target(surLowerFrameSetShadowCasters) {
		draw_clear_alpha(c_white, 0);
	
		// Set Title
		draw_set_font(global.rarityArray[set.baseRarity].hopeFont);
		draw_set_halign(fa_middle);
		draw_text(137, 83, set.name);
	
		// Set Rank
		draw_set_halign(fa_right);
		
		var romanNums = ["N/A", "Rank I","Rank II","Rank III"];
		draw_text(332, 83, romanNums[setRank]);
		
		// Set Description
		draw_set_halign(fa_left);
		draw_set_font(global.fontSinsWhite);
		
		var desc = "Not enough set pieces equipped.";
		if (setRank > 0) then desc = set.tierList[|setRank - 1].description;
		
		draw_text_ext(97, 100, desc, 12, 240);
		
		
		surface_reset_target();
	}

	// Drawing the shadow casters, their shadows
	if !surface_exists(surLowerFrameSetFinal) then surLowerFrameSetFinal = surface_create(global.windowW, global.windowH);
	surface_set_target(surLowerFrameSetFinal) {
		draw_clear_alpha(c_white, 0);

		// Separators
		draw_sprite(sUIInventoryBgFrame2Separator3, 0, 94,	96);
	
		// Shadow Casting Text
		gpu_set_fog(true, $699ce6, 0, 1);
		draw_surface(surLowerFrameSetShadowCasters, 1, 1);
		draw_surface(surLowerFrameSetShadowCasters, 2, 2);
		gpu_set_fog(false, c_white, 0, 1);
	
		draw_surface(surLowerFrameSetShadowCasters, 0, 0);

	surface_reset_target(); }
	
	
}

function lower_frame_state_submit_set_inspect(item) {
	draw_lower_frame_set_inspect(item);
	lower_frame_submit_surface(surLowerFrameSetFinal);
}

// Perk Inspection Lower Frame -----------------------------------------------------------

surLowerFramePerkFinal =				surface_create(global.windowW, global.windowH);
surLowerFramePerkShadowCasters =		surface_create(global.windowW, global.windowH);

function draw_lower_frame_perk_inspect(item, perk) {
	// Things that cast shadows
	if !surface_exists(surLowerFramePerkShadowCasters) then surLowerFramePerkShadowCasters = surface_create(global.windowW, global.windowH);
	surface_set_target(surLowerFramePerkShadowCasters) {
		draw_clear_alpha(c_white, 0);
	
		// Title
		draw_set_font(global.rarityArray[item.bp.rarity].hopeFont);
		draw_text(98, 83, "+" + string(perk.rank) + " to " + perk.bp.name);
	
		// Perk Description
		draw_set_halign(fa_left);
		draw_set_font(global.fontSinsWhite);
		
		var perkTotalRank = 3//perk_get_total_rank(perk.bp);
		var desc = "Rank " + string(perkTotalRank) + ": " + perk_get_rank(perk.bp, perkTotalRank).description;
		
		draw_text_ext(97, 100, desc, 12, 240);
		
		surface_reset_target();
	}

	// Drawing the shadow casters, their shadows
	if !surface_exists(surLowerFramePerkFinal) then surLowerFramePerkFinal = surface_create(global.windowW, global.windowH);
	surface_set_target(surLowerFramePerkFinal) {
		draw_clear_alpha(c_white, 0);

		// Separators
		draw_sprite(sUIInventoryBgFrame2Separator3, 0, 94, 96);
	
		// Shadow Casting Text
		gpu_set_fog(true, $699ce6, 0, 1);
		draw_surface(surLowerFramePerkShadowCasters, 1, 1);
		draw_surface(surLowerFramePerkShadowCasters, 2, 2);
		gpu_set_fog(false, c_white, 0, 1);
	
		draw_surface(surLowerFramePerkShadowCasters, 0, 0);

	surface_reset_target(); }
}

function lower_frame_state_submit_perk_inspect(item, perk) {
	draw_lower_frame_perk_inspect(item, perk);
	lower_frame_submit_surface(surLowerFramePerkFinal);
}

// Lower Frame Management ----------------------------------------------------------------
surLowerFrameFirst =	surface_create(global.windowW, global.windowH);
surLowerFrameSecond =	surface_create(global.windowW, global.windowH);
surLowerFrameNext =		noone;

surLowerFrameFinal =	surface_create(global.windowW, global.windowH);

canCopySecondSurface = false; // If second surface should be converted to first
lowerFrameWipeProgress = 0; // Goes from 0 to 265
lowerFrameWipeSubimg = 0;

#macro LOWER_FRAME_WIPE_PROGRESS 355

function lower_frame_submit_surface(surface) { // Submits a new surface into the queue
	surLowerFrameNext = surface;
}

function lower_frame_override_first_surface(surface) { // Overrides the first surface in the queue, drawn instantly
	if surface_exists(surface) {		
		if surface_exists(surLowerFrameFirst) {
			surface_set_target(surLowerFrameFirst);
			draw_clear_alpha(c_white, 0);
			surface_reset_target();
			surface_copy(surLowerFrameFirst, 0, 0, surface);
		}
		if surface_exists(surLowerFrameSecond) {
			surface_set_target(surLowerFrameSecond);
			draw_clear_alpha(c_white, 0);
			surface_reset_target();
			
			surface_copy(surLowerFrameSecond, 0, 0, surface);
		}
	}
	
	surLowerFrameNext = noone;
	lowerFrameWipeProgress = LOWER_FRAME_WIPE_PROGRESS + 1;
}

function lower_frame_draw_final() { // Processes queue and draws surfaces with the dither wiping effect
	if !surface_exists(surLowerFrameFirst) then surLowerFrameFirst = surface_create(global.windowW, global.windowH);
	if !surface_exists(surLowerFrameSecond) then surLowerFrameSecond = surface_create(global.windowW, global.windowH);
	if !surface_exists(surLowerFrameFinal) then surLowerFrameFinal = surface_create(global.windowW, global.windowH);
	
		/* Queue of surfaces to be drawn. Only goes up to 3 surfaces
	1st -> Surface currently being drawn
	2nd -> Second surface that is being layered on top of the first one, will eventually become first after wipe is finished
	3rd -> Next surface in queue. When second surface is fully converted to first then 3rd becomes 2nd and next wipe begins */
	
	if lowerFrameWipeProgress <= LOWER_FRAME_WIPE_PROGRESS {
		canCopySecondSurface = true;
		lowerFrameWipeProgress = lerp(lowerFrameWipeProgress, LOWER_FRAME_WIPE_PROGRESS + 20, 0.08);
	}
	
	
	if lowerFrameWipeProgress > LOWER_FRAME_WIPE_PROGRESS {
		if canCopySecondSurface { // If there is nothing up next
			surface_set_target(surLowerFrameFirst);
				draw_clear_alpha(c_white, 0);
			surface_reset_target();
			surface_copy(surLowerFrameFirst, 0, 0, surLowerFrameSecond);
			canCopySecondSurface = false;
		}
		
		if surface_exists(surLowerFrameNext) { // If there is a new surface waiting to be drawn
			surface_set_target(surLowerFrameSecond);
				draw_clear_alpha(c_white, 0);
			surface_reset_target();
			surface_copy(surLowerFrameSecond, 0, 0, surLowerFrameNext);
			surLowerFrameNext = noone;
			lowerFrameWipeProgress = 0;
		}	
	}
	
	
	// If in wipe process
	if (lowerFrameWipeProgress <= LOWER_FRAME_WIPE_PROGRESS) {
		surface_set_target(surLowerFrameFinal); {  
			draw_clear_alpha(c_white, 0);
			
			draw_surface_part(surLowerFrameSecond, // Second Surface
			  23, 72, 
			  lowerFrameWipeProgress, 95,
			  23, 72); 
			draw_surface_part(surLowerFrameFirst, // First Surface
			  23 + lowerFrameWipeProgress, 72,
			  LOWER_FRAME_WIPE_PROGRESS - lowerFrameWipeProgress, 95,
			  23 + lowerFrameWipeProgress, 72);
			
			
			gpu_set_blendmode(bm_subtract); // Dither Wipe Effect
				draw_sprite(sUIInventoryDitherWiper, lowerFrameWipeSubimg, 23 + floor(lowerFrameWipeProgress/2) * 2, 72);
			gpu_set_blendmode(bm_normal);
			
			
		surface_reset_target(); }
		
	} else { // If not in wipe progress
		surface_set_target(surLowerFrameFinal); { 
			draw_clear_alpha(c_white, 0);
			
			draw_surface_part(surLowerFrameFirst, // First Surface
			  23, 72,
			  LOWER_FRAME_WIPE_PROGRESS, 95,
			  23, 72);
			
		surface_reset_target(); }
	
	}
}

#endregion

function draw_inspect_page(item) {
	var surfaceToReturnTo = surface_get_target();
	surface_reset_target();
	
	item.bp.rarity = clamp(item.bp.rarity, RARITY.common, RARITY.mythical);
	var rarity = global.rarityArray[item.bp.rarity];

	// Drawing Background -------------------------------------------------------------------------------------------
	if !surface_exists(surBackground) then surBackground = surface_create(global.windowW, global.windowH);
	surface_set_target(surBackground) {
		draw_clear_alpha(c_white, 0);
	
		// Drawing Background Frames
		draw_sprite(sUIInventoryBgFrame1, 0, 83   + x, 4  + y);
	
		// Small Details
		draw_sprite(sUIInventoryBgDecorations1, 0, 83 + x, 66 + y);
	
		// Item Description
		draw_set_font(global.fontHopeCarved);
		draw_set_halign(fa_middle);

		var str = (rarity.name + " " + global.itemTypeNames[item.bp.type]);
		if (item.equippedCharacter != noone) then str = (global.itemTypeNames[item.bp.type] + " - Equipped");

		draw_text(x + 268, y + 11, str);
		draw_set_halign(fa_left);
	
	surface_reset_target(); }

	// Inspecting Logic and Lower Frame -----------------------------------------------------------------------------

	var cursorHoveringSetTitle = cursor_in_box(90 + x, 75 + y, 184 + x, 95 + y);
	if cursorHoveringSetTitle then cursor_skin(2);

	if (lowerFrameWipeProgress >= LOWER_FRAME_WIPE_PROGRESS) {
		if (lowerFrameState != INSPECT_UI_STATE.inspectingSet) and cursorHoveringSetTitle { // Inspect Item Set
			lowerFrameState = INSPECT_UI_STATE.inspectingSet;
			lowerFrameWipeSubimg = 1;
			lower_frame_state_submit_set_inspect(item);
		} 
		
		var perkList = item.perkList;
		var perkAmount = ds_list_size(perkList);
	
		if (lowerFrameState != INSPECT_UI_STATE.inspectingPerk0) and perkIcon[0].hovered { // Inspect First Perk
			lowerFrameState = INSPECT_UI_STATE.inspectingPerk0;
			lowerFrameWipeSubimg = 0;
			if perkAmount > 0 then lower_frame_state_submit_perk_inspect(item, perkList[|0]);
		} else if (lowerFrameState != INSPECT_UI_STATE.inspectingPerk1) and perkIcon[1].hovered { // Inspect Second Perk
			lowerFrameState = INSPECT_UI_STATE.inspectingPerk1;
			lowerFrameWipeSubimg = 1;
			if perkAmount > 1 then lower_frame_state_submit_perk_inspect(item, perkList[|1]);
		} else if (lowerFrameState != INSPECT_UI_STATE.inspectingPerk2) and perkIcon[2].hovered { // Inspect Third Perk
			lowerFrameState = INSPECT_UI_STATE.inspectingPerk2;
			lowerFrameWipeSubimg = 0;
			if perkAmount > 2 then lower_frame_state_submit_perk_inspect(item, perkList[|2]);
		} else if (lowerFrameState != INSPECT_UI_STATE.inspectingPerk3) and perkIcon[3].hovered { // Inspect Fourth Perk
			lowerFrameState = INSPECT_UI_STATE.inspectingPerk3;
			lowerFrameWipeSubimg = 1;
			if perkAmount > 3 then lower_frame_state_submit_perk_inspect(item, perkList[|3]);
		} 
	
		if (lowerFrameState != INSPECT_UI_STATE.standard) and !(cursorHoveringSetTitle or perkIcon[0].hovered or perkIcon[1].hovered or perkIcon[2].hovered or perkIcon[3].hovered) { // Inspect nothing
			lowerFrameState = INSPECT_UI_STATE.standard;
			lowerFrameWipeSubimg = 0;
			lower_frame_state_submit_standard(item);
		}
	}

	if !surface_exists(surCheckForDisappearences) { // In case all surfaces disappear, reset to standard inspect
		surCheckForDisappearences = surface_create(1, 1);
		alarm[0] = 1;	
	}

	lower_frame_draw_final();

	// Lower Buttons ------------------------------------------------------------------------------------------------
	if !surface_exists(surLowerButtons) then surLowerButtons = surface_create(global.windowW, global.windowH);
	surface_set_target(surLowerButtons) {
		draw_clear_alpha(c_white, 0);
		
		// Button X Position
		butUpgrade.x =	114 + x;
		butEquip.x	 =	170 + x;
		butSalvage.x =	226 + x;
		butLock.x	 =	308 + x;
		butBack.x	 =	336 + x;
		
		if alarm[1] <= 0 { // If button animation has finished
			butEquip.shouldDisappear	= (inspectedItem.equippedCharacter != noone);
			butSalvage.shouldDisappear	= (inspectedItem.equippedCharacter != noone or inspectedItem.locked);
		} else switch alarm[1] { // Button Animation (Numbers are frames)
			case 29: butBack.shouldDisappear = false; break;
			case 24: butLock.shouldDisappear = false;
			case 19: butSalvage.shouldDisappear	= (inspectedItem.equippedCharacter != noone or inspectedItem.locked); break;
			case 14:  butEquip.shouldDisappear = (inspectedItem.equippedCharacter != noone); break;
			case 9:  butUpgrade.shouldDisappear = false; break;
		}
		
		
		
		var i; for (i = 0; i < array_length(inspectLowerButtons); i++) {
			var button = inspectLowerButtons[i];
			step_button(button);
			
			button.ySpd = lerp(button.ySpd, ((182 + y + button.shouldDisappear * 50) - button.y) / 2, 0.2); 
			button.y += button.ySpd;
		}

		if butBack.pressed { // Pressing the Back Button (Leaving Inspection)
			butBack.pressedTimer = 0;
			inventoryUIState = INVENTORY_UI_STATE.browsing;
			inspectedItem = noone;
		}
	
		if butEquip.pressed then inspectedItem.equippedCharacter = 0; // Equipping Item
	
		if butLock.pressed then item_lock(inspectedItem);
		
		if inspectedItem != noone and inspectedItem.locked { // Unlocking Item
			butLock.normalSprite = sUIInventoryLockButtonLocked;
			butLock.glowingSprite = sUIInventoryLockButtonLockedGlowing;
		} else { // Locking Item
			butLock.normalSprite = sUIInventoryLockButtonUnlocked;
			butLock.glowingSprite = sUIInventoryLockButtonUnlockedGlowing;
		}
	
	
	surface_reset_target(); }

	// Item Display -------------------------------------------------------------------------------------------------
	if !surface_exists(surItemDisplay) then surItemDisplay = surface_create(global.windowW, global.windowH);
	surface_set_target(surItemDisplay) {
		draw_clear_alpha(c_white, 0);
	
		// Card
		draw_sprite(sUIInventoryItemCardsBig, rarity.ID, x + 137, y + 33);
	
		// Item Sprite
		gpu_set_fog(true, rarity.shadowColor, 0, 1);
		draw_sprite(item.bp.sprite, 0, x + 138, y + 34);
		draw_sprite(item.bp.sprite, 0, x + 139, y + 35);
		gpu_set_fog(false, c_white, 0, 1);
	
		draw_sprite(item.bp.sprite, 0, x + 137, y + 33);
	
		// Item Level
		draw_set_font(rarity.hopeFont);
		draw_set_halign(fa_middle);
	
		draw_text(x + 137, y + 50, "Lv. " + string(item.level));
	
		// Item Name
		draw_set_font(rarity.sinsFont);
		draw_set_halign(fa_middle);
	
		draw_text(x + 137, y + 4, item.bp.name);
	
		// Perk Icons
		step_all_perk_icons(item);
		
		if alarm[1] > 20 then perk_scale_reset(perkIcon[0]);
		if alarm[1] > 15 then perk_scale_reset(perkIcon[1]);
		if alarm[1] > 10 then perk_scale_reset(perkIcon[2]);
		if alarm[1] > 5  then perk_scale_reset(perkIcon[3]);
		
		if inspectedItem != noone { // Popping VFX
			var perkAmount = ds_list_size(inspectedItem.perkList);
		
			switch alarm[1] {
				case 25: if perkAmount > 0 then vfx_pop(perkIcon[0].x, perkIcon[0].y); break;
				case 20: if perkAmount > 1 then vfx_pop(perkIcon[1].x, perkIcon[1].y); break;
				case 15: if perkAmount > 2 then vfx_pop(perkIcon[2].x, perkIcon[2].y); break;
				case 10:  if perkAmount > 3 then vfx_pop(perkIcon[3].x, perkIcon[3].y); break;
			}
		}
	
		draw_set_halign(fa_left);
	surface_reset_target(); }

	// Drawing to final surface -------------------------------------------------------------------------------------
	if !surface_exists(surFinalInspect) then surFinalInspect = surface_create(global.windowW, global.windowH);
	surface_set_target(surFinalInspect) {
		draw_clear_alpha(c_white, 0);
		
		gpu_set_blendmode_ext_sepalpha(bm_src_alpha,bm_inv_src_alpha,bm_src_alpha,bm_one);
		
		// Background
		draw_surface(surBackground, 0, 0);
	
		// Lower Frame Background
		draw_sprite(sUIInventoryBgFrame2, 0, 83 + x, 71 + y);
	
		// Lower Frame
		if !surface_exists(surLowerFrameFinal) then surLowerFrameFinal = surface_create(global.windowW, global.windowH);
		draw_surface(surLowerFrameFinal, x, y);
	
		// Lower Buttons
		gpu_set_fog(true, $9fcaf6, 0, 1);
		draw_surface(surLowerButtons, 1, 1);
		draw_surface(surLowerButtons, 2, 2);
		gpu_set_fog(false, c_white, 0, 1);
	
		draw_surface(surLowerButtons, 0, 0);
	
		// Item Display
		gpu_set_fog(true, $699ce6, 0, 1);
		draw_surface(surItemDisplay, 1, 1);
		draw_surface(surItemDisplay, 2, 2);
		gpu_set_fog(false, c_white, 0, 1);
	
		draw_surface(surItemDisplay, 0, 0);
	
		gpu_set_blendmode(bm_normal);
	surface_reset_target(); }

	surface_set_target(surfaceToReturnTo);
	draw_surface(surFinalInspect, 0, 0);
}

#region Item Browsing Page -----------------------------------------------------------

function draw_item_card(item, glowing, X, Y, scale) {
	if scale > 0.05 {
		var itemCardBackgroundSprites = [sItemCardBackgrounds, sItemCardBackgroundsGlowing];
		var rarity = global.rarityArray[item.bp.rarity];
	
		draw_sprite_ext(itemCardBackgroundSprites[glowing], item.bp.rarity, X, Y - glowing, scale, scale, 0, c_white, 1);
	
		// Favourite Icon
		if item.locked then draw_sprite(sItemCardFavouriteIcon, item.bp.rarity, X - (14 + glowing)*scale, Y - (19 + glowing*2)*scale);
	
		// New Icon
		if item.newlyAcquired then draw_sprite_ext(sItemCardNewIcon, 0, X + 14*scale, Y - (20 + sin(current_time/150))*scale, scale, scale, 0, c_white, 1);
	
		// Item Sprite
		var shadowCol;
		if glowing then shadowCol = rarity.color;
		else shadowCol = rarity.shadowColor;
	
		gpu_set_fog(true, shadowCol, 0, 1);
		draw_sprite_ext(item.bp.sprite, 0, X + 1 * scale, Y + (1 - glowing)*scale, scale, scale, 0, c_white, 1);
		draw_sprite_ext(item.bp.sprite, 0, X + 2 * scale, Y + (2 - glowing)*scale, scale, scale, 0, c_white, 1);
		gpu_set_fog(false, c_white, 0, 1);
	
		draw_sprite_ext(item.bp.sprite, 0, X, Y - glowing*scale,  scale, scale, 0, c_white, 1);
	
		// Level
		draw_set_font(rarity.hopeFont);
		draw_set_halign(fa_right);
		draw_text_transformed(X + (17 + glowing)*scale, Y + 16*scale, item.level, scale, scale, 0);
		draw_set_halign(fa_left);
	}
}

function step_item_card(item, X, Y) {
	var hovered = cursor_in_box(X - 19, Y - 24, X + 19, Y + 24);
	if hovered then cursor_skin(1);
	
	if hovered {
		inspectedItem = item;
		alarm[2] = 6; // We use a delay so it's not constantly flashing between names
		if item.newlyAcquired and alarm[4] <= 0 {
			item.newlyAcquired = false;
			instance_create_depth(X + 12, Y - 20, depth-1, oNewCatchParticle);
			part_emitter_region(global.part_system_HUD, emitter1, X + 14, X + 10, Y - 22, Y - 18, ps_shape_ellipse, ps_distr_linear);
			part_emitter_burst(global.part_system_HUD, emitter1, particlesNewCatch, 10);
		}
	}
	
	if hovered and oPlayer.inputs.mbLeft[PRESSED] {
		inventoryUIState = INVENTORY_UI_STATE.inspecting;
		inspect_buttons_reset();
		inspect_perks_reset();
		draw_lower_frame_standard(inspectedItem);
		lower_frame_override_first_surface(surLowerFrameStandardFinal);
	}

	draw_item_card(item, hovered, X, Y, 1);
}

function draw_browsing_page() {
	var surfaceToReturnTo = surface_get_target();
	surface_reset_target();
	
	#region Upper Frame
		if !surface_exists(surUpperFrameShadowCasters) then surUpperFrameShadowCasters = surface_create(global.windowW, global.windowH);
		surface_set_target(surUpperFrameShadowCasters) { // Things that cast shadows
			draw_clear_alpha(c_white, 0);
		
			// Buttons
			var buttons = [butSort1, butSort2, butSort3];
			butSort1.x = 208 + x;
			butSort2.x = 262 + x;
			butSort3.x = 318 + x;
			
			for (i = 0; i < array_length(buttons); i++) {
				var button = buttons[i];
				
				step_button(button);
				button.y = 23 + y;
				
				if button.pressed { // Selecting New Filter Option
					button.pressed = false;
					
					button.optionSelected ++;
					if button.optionSelected >= array_length(button.textOptions) then button.optionSelected = 0; // Cycling Back
					button.text = button.textOptions[button.optionSelected]; // Changing Text Within Array
				
					sort_buttons_generate_new_list();
				}
			}
			
			
			if inspectedItem != noone { // Drawing Inspected Item Name
				var rarity = global.rarityArray[inspectedItem.bp.rarity];
				
				draw_set_font(rarity.sinsFont);
				draw_set_halign(fa_middle);
				draw_text(133 + x, 10 + y, inspectedItem.bp.name);
				
				draw_set_font(rarity.hopeFont);
				draw_text(133 + x, 28 + y, "Lv." + string(inspectedItem.level));
				
				draw_set_halign(fa_left);
			} else { // Total Item Count
				draw_set_font(global.fontSinsCommon);
				draw_set_halign(fa_middle);
				draw_text(133 + x, 10 + y, "Total Items");
				
				draw_set_font(global.fontHopeCommon);
				draw_text(133 + x, 28 + y, ds_list_size(global.uniqueStorage.items));
				
				draw_set_halign(fa_left);
			}
			
		
		surface_reset_target(); }
		
		if !surface_exists(surUpperFrame) then surUpperFrame = surface_create(global.windowW, global.windowH);
		surface_set_target(surUpperFrame) { // Final Upper Frame
			draw_clear_alpha(c_white, 0);
			
			// Drawing Background Frame
			draw_sprite(sUIInventoryBgFrame3, 0, 83 + x, 4 + y);
		
			// Drawing Shadow Casters
			gpu_set_fog(true, $699ce6, 0, 1);
			draw_surface(surUpperFrameShadowCasters, 1, 1); 
			draw_surface(surUpperFrameShadowCasters, 2, 2);
			gpu_set_fog(false, c_white, 0, 0);
			draw_surface(surUpperFrameShadowCasters, 0, 0);
		
		surface_reset_target(); }
	#endregion

	#region Item Grid
		if !surface_exists(surItemGridShadowCasters) then surItemGridShadowCasters = surface_create(global.windowW, global.windowH);
		surface_set_target(surItemGridShadowCasters) { // Things that cast shadows
			draw_clear_alpha(c_white, 0);
			
			itemGrid.step();
			
		surface_reset_target(); }
		
		if !surface_exists(surItemGrid) then surItemGrid = surface_create(global.windowW, global.windowH);
		surface_set_target(surItemGrid) { // Final Upper Frame
			draw_clear_alpha(c_white, 0);
			
			// Drawing Shadow Casters
			gpu_set_fog(true, $9fcaf6, 0, 1);
			draw_surface(surItemGridShadowCasters, 1, 1); 
			draw_surface(surItemGridShadowCasters, 2, 2);
			gpu_set_fog(false, c_white, 0, 0);
			draw_surface(surItemGridShadowCasters, 0, 0);
		
			// Item Grid Fade
			gpu_set_blendmode(bm_subtract);
			draw_sprite(sUIInventoryItemCardClearer, 0, 41, 0);
			gpu_set_blendmode(bm_normal);
			
		surface_reset_target(); }

	#endregion
	
	#region Final
		if !surface_exists(surFinalBrowse) then surFinalBrowse = surface_create(global.windowW, global.windowH);
		surface_set_target(surFinalBrowse) { // Final Surface
			draw_clear_alpha(c_white, 0);
		
			// Upper Frame
			draw_surface(surUpperFrame, 0, 0);
			
			// Item Grid
			draw_surface(surItemGrid, 0, 0);
			
		surface_reset_target(); }
	#endregion
	
	surface_set_target(surfaceToReturnTo);
	draw_surface(surFinalBrowse, 0, 0);
}



#endregion ---------------------------------------------------------------------------

xSpd = 0;
showing = false;

// Testing Purposes
inspectedItem = noone;

// Particles
particlesNewCatch = part_type_create(); // Mana Sprinkles
part_type_speed(particlesNewCatch, 2, 3, -0.2, 0);
part_type_direction(particlesNewCatch, 0, 360, 0, 2);
part_type_gravity(particlesNewCatch, 0.03, 270);
part_type_orientation(particlesNewCatch, 0, 360, 2, 5, 0);
part_type_size(particlesNewCatch, 0.40, 0.80, -0.02, 0.2);
part_type_scale(particlesNewCatch, 0.1, 0.1);
part_type_life(particlesNewCatch, 0.3 * 60, 0.6 * 60);
part_type_blend(particlesNewCatch, false);
part_type_color_mix(particlesNewCatch, $ffffff, $ddcfc7);
part_type_alpha2(particlesNewCatch, 1, 1);
part_type_shape(particlesNewCatch, pt_shape_square);

emitter1 = part_emitter_create(global.part_system_HUD);
