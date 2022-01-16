if yRel > -280 {

draw_self()

//Next/Previous Page
var cursorInPrevPage = cursor_in_box(x+48,y+9,x+48+27,y+9+15)
var cursorInNextPage = cursor_in_box(x+48*2,y+9,x+48*2+27,y+9+15)

#region Selecting the page
if cursorInPrevPage or cursorInNextPage {
	cursor_skin(1)
	
	var dir = cursorInNextPage - cursorInPrevPage
	
	if mbLeft[PRESSED] {
		selectedPage += dir
		
		
	
		if selectedPage <= 0 then selectedPage = 3
		else if selectedPage >= 4 then selectedPage = 1
	
		redrawThreeItems = true
		redrawItemDesc = true
	}
	
}
#endregion

draw_sprite(sUIShopPrevPage,cursorInPrevPage,x+48,y+9)
draw_sprite(sUIShopNextPage,cursorInNextPage,x+48*2,y+9)

#region Page Number -----------------------------
draw_set_font(global.fontHopeWhite)

gpu_set_fog(true,$9fcaf6,0,1)
draw_text(x+99,y+34,selectedPage)
gpu_set_fog(false,$9fcaf6,0,1)

draw_text(x+98,y+33,selectedPage)

#endregion

#region 3 Listed Items --------------------------
var rarityFonts = [global.fontHopeWhite,global.fontHopeUncommon,global.fontHopeRare,global.fontHopeEpic,global.fontHopeLegendary,global.fontHopeFabled,global.fontHopeMythic]
var rarityColors = [ $b9a192,$4fc55a,$dc9800,$f589f3,$3874e0,$5d55f5,$fa097a]

if !surface_exists(sfThreeItems) or redrawThreeItems {

if !surface_exists(sfThreeItems) then sfThreeItems = surface_create(global.windowW,global.windowH)
redrawThreeItems = false

surface_set_target(sfThreeItems)
draw_clear_alpha(c_white,0)

#region First Listed Item
var selectedItemNumber = selectedPage*3-3

if (selectedItemNumber+1) <= ds_list_size(global.itemList) and item_get_unlocked(global.itemList[| selectedItemNumber]) { //If it's unlocked-----------------
	//Getting Attributes
	var item = global.itemList[| selectedItemNumber]
	var itemRarity = item_get_rarity(item)
	var itemName = item_get_name(item)
	var itemTotalCPS = item_get_totalcps(item)
	var itemTotalCPSStr = price_string(itemTotalCPS) + price_order(itemTotalCPS) + " cps"
	var itemMinisprite = item_get_minisprite(item)
	
	//Drawing Background Sprite
	draw_sprite(sUIShopItemBg,itemRarity,40,51)

	//Drawing name & cps shadows
	draw_set_font(global.fontHopeWhite)

	gpu_set_fog(true,rarityColors[itemRarity],0,1)
	draw_text(46,56,itemName)
	draw_text(47,57,itemName)
	draw_text(46,66,itemTotalCPSStr)
	draw_text(47,67,itemTotalCPSStr)
	gpu_set_fog(false,c_white,0,1)

	//Drawing Minisprite
	draw_sprite(itemMinisprite,itemRarity,110,54)

	//Drawing Name
	draw_set_font(rarityFonts[itemRarity])
	draw_text(45,55,itemName)

	//Drawing total CPS
	draw_set_font(global.fontHopeGold)
	draw_text(45,65,itemTotalCPSStr)
} else { //If it's locked------------------------------------
	//Drawing Background Sprite
	draw_sprite(sUIShopItemBg,0,40,51)
	
	//Drawing text
	draw_set_font(global.fontHopeWhite)
	
	gpu_set_fog(true,$b9a192,0,1)
	draw_text(66,61,"locked")
	draw_text(67,62,"locked")
	gpu_set_fog(false,c_white,0,1)
	
	draw_text(65,60,"locked")
}
#endregion

#region Second Listed Item
var selectedItemNumber = selectedPage*3-2

if (selectedItemNumber+1) <= ds_list_size(global.itemList) and item_get_unlocked(global.itemList[| selectedItemNumber]) { //If it's unlocked-----------------
	//Getting Attributes
	var item = global.itemList[| selectedItemNumber]
	var itemRarity = item_get_rarity(item)
	var itemName = item_get_name(item)
	var itemTotalCPS = item_get_totalcps(item)
	var itemTotalCPSStr = price_string(itemTotalCPS) + price_order(itemTotalCPS) + " cps"
	var itemMinisprite = item_get_minisprite(item)
	
	//Drawing Background Sprite
	draw_sprite(sUIShopItemBg,itemRarity,40,51+36)

	//Drawing name & cps shadows
	draw_set_font(global.fontHopeWhite)

	gpu_set_fog(true,rarityColors[itemRarity],0,1)
	draw_text(46,56+36,itemName)
	draw_text(47,57+36,itemName)
	draw_text(46,66+36,itemTotalCPSStr)
	draw_text(47,67+36,itemTotalCPSStr)
	gpu_set_fog(false,c_white,0,1)

	//Drawing Minisprite
	draw_sprite(itemMinisprite,itemRarity,110,54+36)

	//Drawing Name
	draw_set_font(rarityFonts[itemRarity])
	draw_text(45,55+36,itemName)

	//Drawing total CPS
	draw_set_font(global.fontHopeGold)
	draw_text(45,65+36,itemTotalCPSStr)
} else { //If it's locked------------------------------------
	//Drawing Background Sprite
	draw_sprite(sUIShopItemBg,0,40,51+36)
	
	//Drawing text
	draw_set_font(global.fontHopeWhite)
	
	gpu_set_fog(true,$b9a192,0,1)
	draw_text(66,61+36,"locked")
	draw_text(67,62+36,"locked")
	gpu_set_fog(false,c_white,0,1)
	
	draw_text(65,60+36,"locked")
}

#endregion

#region Third Listed Item
var selectedItemNumber = selectedPage*3-1

if (selectedItemNumber+1) <= ds_list_size(global.itemList) and item_get_unlocked(global.itemList[| selectedItemNumber]) { //If it's unlocked-----------------
	//Getting Attributes
	var item = global.itemList[| selectedItemNumber]
	var itemRarity = item_get_rarity(item)
	var itemName = item_get_name(item)
	var itemTotalCPS = item_get_totalcps(item)
	var itemTotalCPSStr = price_string(itemTotalCPS) + price_order(itemTotalCPS) + " cps"
	var itemMinisprite = item_get_minisprite(item)
	
	//Drawing Background Sprite
	draw_sprite(sUIShopItemBg,itemRarity,40,51+36+36)

	//Drawing name & cps shadows
	draw_set_font(global.fontHopeWhite)

	gpu_set_fog(true,rarityColors[itemRarity],0,1)
	draw_text(46,56+36+36,itemName)
	draw_text(47,57+36+36,itemName)
	draw_text(46,66+36+36,itemTotalCPSStr)
	draw_text(47,67+36+36,itemTotalCPSStr)
	gpu_set_fog(false,c_white,0,1)

	//Drawing Minisprite
	draw_sprite(itemMinisprite,itemRarity,110,54+36+36)

	//Drawing Name
	draw_set_font(rarityFonts[itemRarity])
	draw_text(45,55+36+36,itemName)

	//Drawing total CPS
	draw_set_font(global.fontHopeGold)
	draw_text(45,65+36+36,itemTotalCPSStr)
} else { //If it's locked------------------------------------
	//Drawing Background Sprite
	draw_sprite(sUIShopItemBg,0,40,51+36+36)
	
	//Drawing text
	draw_set_font(global.fontHopeWhite)
	
	gpu_set_fog(true,$b9a192,0,1)
	draw_text(66,61+36+36,"locked")
	draw_text(67,62+36+36,"locked")
	gpu_set_fog(false,c_white,0,1)
	
	draw_text(65,60+36+36,"locked")
}

#endregion

surface_reset_target()

}

if surface_exists(sfThreeItems) then draw_surface(sfThreeItems,x,y)

#endregion

#region Item Selected Marker --------------------
var cursorInItem1 = cursor_in_box(x+40,y+51,x+132,y+76)
var cursorInItem2 = cursor_in_box(x+40,y+87,x+132,y+87+25)
var cursorInItem3 = cursor_in_box(x+40,y+123,x+132,y+123+25)

if cursorInItem1 {
	lastHoveredBox = 1
	draw_sprite(sUIShopBackgroundOutline,0,x+40,y+51)	
} else if cursorInItem2 {
	lastHoveredBox = 2
	draw_sprite(sUIShopBackgroundOutline,0,x+40,y+87)	
} else if cursorInItem3 {
	lastHoveredBox = 3
	draw_sprite(sUIShopBackgroundOutline,0,x+40,y+123)	
}

if lastHoveredBoxPrevious != lastHoveredBox then redrawItemDesc = true

lastHoveredBoxPrevious = lastHoveredBox

itemSelectedIndicatorX = lerp(itemSelectedIndicatorX,(lastHoveredBox-1)*36,0.2)

draw_sprite(sUIShopSelector,itemSelectedIndicatorFrame,x+34,round(y+45+itemSelectedIndicatorX))
#endregion

#region Item Desc -------------------------------

if !surface_exists(sfItemDesc) or redrawItemDesc {
	if !surface_exists(sfItemDesc) then sfItemDesc = surface_create(global.windowW,global.windowH)
	redrawItemDesc = false
	
	updateSelectedPrice = true
	
	surface_set_target(sfItemDesc)
	draw_clear_alpha(c_white,0)
	
	var selectedItemNumber = (selectedPage*3 - 4 + lastHoveredBox)

	if selectedItemNumber < ds_list_size(global.itemList) and item_get_unlocked(global.itemList[| selectedItemNumber]) {
		selectedItem = global.itemList[| selectedItemNumber]
		lastHoveredBoxValid = lastHoveredBox
		lastValidPage = selectedPage
	}
	
	var itemRarity = item_get_rarity(selectedItem)
	var itemSprite = item_get_sprite(selectedItem)
	var itemLevel = item_get_level(selectedItem)
	var itemName = item_get_name(selectedItem)
	
	draw_sprite(sUIShopRarityDisplays,itemRarity,149,33)
	
	draw_set_font(rarityFonts[itemRarity])
	gpu_set_fog(true,$9fcaf6,0,1)
	draw_text(172,47,itemLevel)
	draw_text(173,48,itemLevel)
	gpu_set_fog(false,c_white,0,1)
	
	draw_text(171,46,itemLevel)
	
	draw_sprite(itemSprite,itemRarity,196,24)
	
	//Item Description
	draw_set_font(global.fontSinsWhite)
	
	var itemDesc = item_get_desc(selectedItem);
	
	gpu_set_fog(true,$9fcaf6,0,1)
	draw_text_ext(150,78,itemDesc,10,95)
	draw_text_ext(151,79,itemDesc,10,95)
	gpu_set_fog(false,c_white,0,1)
	
	draw_text_ext(149,77,itemDesc,10,95)
	
	
	
	surface_reset_target()
}


if surface_exists(sfItemDesc) {
	draw_surface(sfItemDesc,x,y)

	if alarm[3] > 0 {
		gpu_set_fog(true,c_white,0,1)
		draw_surface_part_ext(sfItemDesc,0,0,400,75,x,y,1,1,c_white,round(alarm[3]/2.5)*2.5/15)
		if selectedPage = lastValidPage then draw_sprite_ext(sUIShopWhiteSprite1,0,x+40,y+51+(lastHoveredBoxValid-1)*36,1,1,0,c_white,round(alarm[3]/2.5)*2.5/15)
		gpu_set_fog(false,c_white,0,1)
	}
}
#endregion

#region Buy Region -----------------------------

#region Price

if updateSelectedPrice then {
	updateSelectedPrice = false
	
	selectedItemPrice = item_get_next_prices(selectedItem,selectedPrices[selectedItemPriceNumber])
	selectedItemPriceString = price_string(selectedItemPrice) + price_order(selectedItemPrice)
}

draw_set_font(global.fontHopeGold)

gpu_set_fog(true,$9fcaf6,0,1)
draw_text(x+180,y+126,selectedItemPriceString)
draw_text(x+181,y+127,selectedItemPriceString)
gpu_set_fog(false,c_white,0,1)

draw_text(x+179,y+125,selectedItemPriceString)

#endregion

#region Change Prices and Quantities

var cursorInBuyLeft = cursor_in_box(x+148,y+135,x+163,y+155)
var cursorInBuyRight = cursor_in_box(x+226,y+135,x+241,y+155)

if cursorInBuyLeft or cursorInBuyRight then cursor_skin(1)

if mbLeft[PRESSED] and (cursorInBuyLeft or cursorInBuyRight) {
	if cursorInBuyLeft {
		selectedItemPriceNumber --
		changeButtonClicked = 0
	}
	else if cursorInBuyRight {
		selectedItemPriceNumber ++
		changeButtonClicked = 1
	}
	
	alarm[1] = 14
	
	if selectedItemPriceNumber >= 3 then selectedItemPriceNumber = 0
	else if selectedItemPriceNumber < 0 then selectedItemPriceNumber = 2
	
	updateSelectedPrice = true
	
}

draw_sprite(sUIShopChangeButtons,changeButtonClicked+2*(alarm[1]>0),x+148,y+135)

#endregion

var canBuy = price_add(playerStats.money,MINUS,selectedItemPrice) != -1

if canBuy draw_sprite(sUIShopBuyButton,selectedItemPriceNumber+4*(alarm[2]>0),x+166,y+138)
else draw_sprite(sUIShopBuyButtonRed,selectedItemPriceNumber,x+166,y+138)

var cursorInBuyBox = cursor_in_box(x+166,y+138,x+223,y+152)

if cursorInBuyBox and canBuy {
	cursor_skin(1)
	
	
	if mbLeft[PRESSED] {
		repeat selectedPrices[selectedItemPriceNumber] {
			if price_add(playerStats.money,MINUS,item_get_price(selectedItem)) != -1 {
				playerStats.money = price_add(playerStats.money,MINUS,item_get_price(selectedItem))
				item_increase_level(selectedItem)
				alarm[3] = lerp(alarm[3],20,0.5)
			
				part_emitter_region(global._part_system_2, global._part_emitter_4, x+215,x+240,y+33,y+72, ps_shape_rectangle, ps_distr_linear)
				part_emitter_burst(global._part_system_2,global._part_emitter_4,global._part_type_13,3)
				if chance(0.5) part_emitter_burst(global._part_system_2,global._part_emitter_4,global._part_type_14,1)
				
				if selectedPage = lastValidPage {
					part_emitter_region(global._part_system_2, global._part_emitter_4, x+40,x+140,y+51+(lastHoveredBoxValid-1)*36,y+70+(lastHoveredBoxValid-1)*36, ps_shape_rectangle, ps_distr_linear)
					part_emitter_burst(global._part_system_2,global._part_emitter_4,global._part_type_13,2)
					if chance(0.5) part_emitter_burst(global._part_system_2,global._part_emitter_4,global._part_type_14,1)
				}
			}
			
		
		redrawItemDesc = true
		updateSelectedPrice = true
		redrawThreeItems = true
		
		alarm[2] = 14
		}
		
	update_player_stats();
	}
	
	
}

#endregion

#region Currency Display
draw_set_font(global.fontAlagardGoldOutlined)
draw_set_halign(fa_middle)
draw_text(x+195,y+7,price_string(playerStats.money) + price_order(playerStats.money))
draw_set_halign(fa_left)

#endregion

}

#region Leave Button
var cursorInLeaveBox = cursor_in_box(x+12,y+36,x+30,y+62)
draw_sprite(sUILeaveButtonGeneral,cursorInLeaveBox,x+12,y+36)

if cursorInLeaveBox {
	cursor_skin(1)
	
	if mbLeft[PRESSED] then global.UIElementShowing = UI_NOTHING
}

#endregion

#region Particles
if !surface_exists(sfParts) then sfParts = surface_create(global.windowW,global.windowH)

part_system_automatic_draw(global._part_system_2,false)

surface_set_target(sfParts)
draw_clear_alpha(c_white,0)
part_system_drawit(global._part_system_2)
surface_reset_target()

//gpu_set_blendmode(bm_add)
draw_surface(sfParts,0,0)
//gpu_set_blendmode(bm_normal)

part_system_automatic_draw(global._part_system_2,true)
#endregion
