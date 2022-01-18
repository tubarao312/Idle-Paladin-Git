draw_set_alpha(1);
gpu_set_blendmode(bm_normal);

if keyboard_check_pressed(ord("R")) then item = global.testBelt;
if keyboard_check_pressed(ord("T")) then item = global.testSword;
if keyboard_check_pressed(vk_control) then inventoryUIState = INVENTORY_UI_STATE.browsing;


#region Inventory UI Logic -----------------------------------------

if !surface_exists(surFinal) then surFinal = surface_create(global.windowW, global.windowH);
if x >= -390 {
	surface_set_target(surFinal)
	draw_clear_alpha(c_white, 0);
	
	// Drawing the background page
	draw_sprite(sUIInventoryBackground, 0, 35 + x, 0 + y);
	
	switch (inventoryUIState) { // State Machine
		case INVENTORY_UI_STATE.browsing: {
			draw_browsing_page();
		break; }
		case INVENTORY_UI_STATE.inspecting: {
			draw_inspect_page(inspectedItem);
		break; }
	}
	
	// Exit Button
	butExit.x = 368 + x;
	butExit.y = 17 + y;
	step_button(butExit);
	if butExit.pressed {
		sort_buttons_reset();
		showing = false;
	}
	
	// Drawing the scroll bar
	draw_sprite(sUIInventoryScrollBarBackground, 0, 356 + x, 30 + y);
	
	// If the scroll bar is being hovered, then it glows
	var spriteWidth = sprite_get_width(scrollBarSprite);
	var spriteHeight = sprite_get_height(scrollBarSprite);
	
	cursorInBar = cursor_in_box(scrollBarX + spriteWidth/2 + 1 + x ,
								60 + scrollBarY + spriteHeight/2 + 1 + y,
								scrollBarX - spriteWidth/2 - 1 + x,
								60 + scrollBarY - spriteHeight/2 - 1 + y);
	
	var scrollBarSpriteGlowing = (cursorInBar or scrollBarState == SCROLL_BAR_STATE.dragged);
	if scrollBarSpriteGlowing then cursor_skin(1);
	draw_sprite(scrollBarSprite, scrollBarSpriteGlowing, scrollBarX + x, 60 + scrollBarY + y);
	
	print(scrollBarY);
	
	// Drawing New Catch Particles
	with (oNewCatchParticle) {
		draw_self();
	}

surface_reset_target(); }

#endregion

// Making Inventory Show
if keyboard_check_pressed(ord("I")) then showing = true;

#region Item Scrolling --------------------------------


// Scroll Bar Controls
if scrollBarState != SCROLL_BAR_STATE.inactive {
	
	
	// Entering Dragged State
	if cursorInBar and oPlayer.inputs.mbLeft[PRESSED] {
		scrollBarCursorYPrevious = global.cursorY;
		scrollBarState = SCROLL_BAR_STATE.dragged;
	}
	
	// Leaving Dragged State
	if scrollBarState == SCROLL_BAR_STATE.dragged and oPlayer.inputs.mbLeft[RELEASED] then scrollBarState = SCROLL_BAR_STATE.standard;
	
	if scrollBarState == SCROLL_BAR_STATE.standard { // Bar is following after targetItemRow
		scrollBarSprite = sUIInventoryScrollBarStandard;
		
		scrollBarPercentage = lerp(scrollBarPercentage, targetItemRow / max(1, (totalItemRows - 3)), 0.2);
		scrollBarPercentage = clamp(scrollBarPercentage, 0, 1);
		scrollBarY = scrollBarPercentage*106;
	} else { // Bar is being dragged by mouse
		scrollBarSprite = sUIInventoryScrollBarDragged;
		
		var scrollBarCursorY = global.cursorY;
		
		// Detects cursor movement and moves scroll bar accordingly
		scrollBarY += (scrollBarCursorY - scrollBarCursorYPrevious);
		scrollBarY = clamp(scrollBarY, 0, 106);
		scrollBarPercentage = scrollBarY / 106; // Percentage is updated
		targetItemRow = round(scrollBarPercentage * totalItemRows); // Target Item Row follows percentage
		
		
		
		scrollBarCursorYPrevious = scrollBarCursorY;
	}
	
} else {
	scrollBarSprite = sUIInventoryScrollBarStandard;
}

// If the scroll bar is being hovered, then it glows
var scrollBarSpriteGlowing = (scrollBarState != SCROLL_BAR_STATE.standard or cursorInBar);
draw_sprite(scrollBarSprite, scrollBarSpriteGlowing, scrollBarX + x, 50 + scrollBarY + y);


// Wheel Controls
if mouse_wheel_down() then targetItemRow++;
if mouse_wheel_up() then targetItemRow--;

// Logic
targetItemRow = clamp(targetItemRow, 0, max(0, totalItemRows-3));

scrollTargetY = (targetItemRow) * 50;
scrollY = lerp(scrollY, scrollTargetY, 0.2);

currentItemRow = round(scrollY / 50);

if (previousItemRow > currentItemRow) {
	fadingLowCardScale = 1;
	fadingHighCardScale = 0;
	goingUp = true;
	alarm[3] = 7;
	alarm[4] = 15;
} else if (previousItemRow < currentItemRow) {
	fadingLowCardScale = 1;
	fadingHighCardScale = 1;
	goingUp = false;
	alarm[3] = 3;
	alarm[4] = 15;
}


if alarm[3] > 0 {
	fadingHighCardScale = lerp(fadingHighCardScale, goingUp, 0.25 - !goingUp * 0.20);
} else {
	fadingHighCardScale = lerp(fadingHighCardScale, 0, 0.15);
}

previousItemRow = currentItemRow;

#endregion ----------------------------------------------


// Making Mana and HP Bars Disappear
global.showHUD = !showing;

if showing then xTarget = -42;
else xTarget = -400;

x = lerp(x, xTarget, 0.1);