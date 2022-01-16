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
	
	// Drawing New Catch Particles
	with (oNewCatchParticle) {
		draw_self();
	}

surface_reset_target(); }

#endregion

// Making Inventory Show
if keyboard_check_pressed(ord("I")) then showing = true;

// Item Scrolling
if mouse_wheel_down() then targetItemRow++;
if mouse_wheel_up() then targetItemRow--;
targetItemRow = clamp(targetItemRow, 0, max(0, totalItemRows-3));

scrollTargetY = (targetItemRow) * 50;
scrollY = lerp(scrollY, scrollTargetY, 0.2);

currentItemRow = round(scrollY / 50);

if (previousItemRow > currentItemRow) {
	fadingLowCardScale = 1;
	fadingHighCardScale = 0;
	print("Up");
	goingUp = true;
	alarm[3] = 7;
	alarm[4] = 15;
} else if (previousItemRow < currentItemRow) {
	fadingLowCardScale = 1;
	fadingHighCardScale = 1;
	goingUp = false;
	print("Down");
	alarm[3] = 3;
	alarm[4] = 15;
}



if alarm[3] > 0 {
	fadingHighCardScale = lerp(fadingHighCardScale, goingUp, 0.25 - !goingUp * 0.20);
} else {
	fadingHighCardScale = lerp(fadingHighCardScale, 0, 0.15);
}

previousItemRow = currentItemRow;




// Making Mana and HP Bars Disappear
global.showHUD = !showing;

if showing then xTarget = -42;
else xTarget = -400;

x = lerp(x, xTarget, 0.1);