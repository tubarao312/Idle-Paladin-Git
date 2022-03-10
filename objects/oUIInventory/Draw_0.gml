draw_set_alpha(1);
gpu_set_blendmode(bm_normal);

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
	
	// Scroll Bar Logic
	scrollBar.step();
	
	// Drawing Scroll Bar
	scrollBar.draw();
	
	// Drawing New Catch Particles
	with (oNewCatchParticle) {
		draw_self();
	}

surface_reset_target(); }

#endregion

// Making Inventory Show
if keyboard_check_pressed(ord("I")) then showing = true;

// Making Mana and HP Bars Disappear
global.showHUD = !showing;

if showing then xTarget = -42;
else {
	alarm[5] = 30;
	itemGrid.state = ITEM_GRID_STATE.browse;
	itemGrid.reset();
	
	xTarget = -400;
}

x = lerp(x, xTarget, 0.1);