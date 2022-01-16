var shouldDraw = (yRel > -250);

if shouldDraw {

part_system_automatic_draw(global._part_system,false)

draw_self()

//Next/Previous Page
var cursorInPrevPage = cursor_in_box(x+48,y+9,x+48+27,y+9+15)
var cursorInNextPage = cursor_in_box(x+48*2,y+9,x+48*2+27,y+9+15)

#region Selecting the page
if cursorInPrevPage or cursorInNextPage {
	cursor_skin(1)
	
	var dir = cursorInNextPage - cursorInPrevPage
	
	if mbLeft[PRESSED] {
		page += dir
		
		shake = array_create(maxPages*16,0)
		xRela = 0
		yRela = 0
		
		if page <= 0 then page = maxPages
		else if page >= maxPages+1 then page = 1
	}
	
	
}
#endregion

draw_sprite(sUIShopPrevPage,cursorInPrevPage,x+48,y+9)
draw_sprite(sUIShopNextPage,cursorInNextPage,x+48*2,y+9)

#region Page Number -----------------------------
draw_set_font(global.fontHopeWhite)

gpu_set_fog(true,$9fcaf6,0,1)
draw_text(x+99,y+34,page)
gpu_set_fog(false,$9fcaf6,0,1)

draw_text(x+98,y+33,page)

#endregion

#macro X_OFFSET 40
#macro Y_OFFSET 47

#region Drawing Description


var state = frame_get_state(lastHoveredUpgrade)
var cost = frame_get_cost(lastHoveredUpgrade)
var name = frame_get_name(lastHoveredUpgrade)
var desc = frame_get_desc(lastHoveredUpgrade)

//Name
var nameFonts = [global.fontHopeFabled,global.fontHopeUncommon,global.fontHopeRare]
draw_set_font(nameFonts[state-1])
gpu_set_fog(true,$9fcaf6,0,1)
draw_text(x+149,y+34,name)
gpu_set_fog(false,c_white,0,1)
draw_text(x+148,y+33,name)

//Desc
draw_set_font(global.fontSinsWhite)

gpu_set_fog(true,$9fcaf6,0,1)
draw_text_ext(x+149,y+47,desc,12,95)
draw_text_ext(x+150,y+48,desc,12,95)
gpu_set_fog(false,c_white,0,1)
	
draw_text_ext(x+148,y+46,desc,12,95)

//Cost
draw_set_font(global.fontHopeGold)
var cost;
if state != 3 then cost = price_string(cost)+price_order(cost)
else cost = "Acquired"

gpu_set_fog(true,$9fcaf6,0,1)
draw_text_ext(x+180,y+141,cost,10,95)
draw_text_ext(x+181,y+142,cost,10,95)
gpu_set_fog(false,c_white,0,1)

draw_text(x+179,y+140,cost)

//Lines
draw_sprite(sUIUpgradeLines,state-1,x,y)

#endregion

//Adding the bought and buyable lists together
if renewShownList {
	global.frameListBuyable = frame_list_organize(global.frameListBuyable,true)
	global.frameListBought = frame_list_organize(global.frameListBought,false)
	
	ds_list_copy(global.frameListShown, global.frameListBuyable)
	
	for (i = ds_list_size(global.frameListBought)-1; i >= 0; i --) {
		ds_list_add(global.frameListShown,global.frameListBought[| i])
	}

	renewShownList = false
}

var hoveringAnUpgrade = false
var i;

for (i = 0; i < 16; i++) {
	var X = X_OFFSET + x + i%4 * 24
	var Y = Y_OFFSET + y + floor(i/4) * 26
	var frameNumber = (page-1)*16 + i
	
	var cursorInBox = cursor_in_box(X,Y,X+20,Y+20)
	
	if cursorInBox then hoveringAnUpgrade = true
	
	if frameNumber >= ds_list_size(global.frameListShown) {
		draw_sprite(sUIUpgradeFrame,0+cursorInBox*4,X-1,Y-1)
	} else {
		var ID = global.frameListShown[| frameNumber]
		var state = frame_get_state(ID)
		#region Updating RED AND GREEN
		if state != 3 and ((updatePrices or !showUpPrev) and showUp) {
			var cost = frame_get_cost(ID)

			if price_add(cost,MINUS,playerStats.money) != -1 {
				frame_set_state(ID,1)
				if state = 2 then shake[frameNumber] = 1.5
				state = 1
			} else {
				frame_set_state(ID,2)
				state = 2
			}
		}
		#endregion
		
		var symbol = frame_get_symbol(ID)
		
		if cursorInBox {
			if state = 2 then cursor_skin(1)
			if state > 0 then lastHoveredUpgrade = ID
			
			ID.newFrame = false;
			
			if mbLeft[PRESSED] and state = 2 then boughtUpgrade = ID
			
			if mbLeft[HELD] and boughtUpgrade = lastHoveredUpgrade and state = 2 {
				confirmPercent += 0.04
				shake[frameNumber] += 0.095
			} else {
				confirmPercent = 0
				shake[frameNumber]= 0
			}
			
			if confirmPercent >= 1 {
				frame_set_state(boughtUpgrade,3)
				playerStats.money = price_add(playerStats.money,MINUS,frame_get_cost(boughtUpgrade))
				confirmPercent = 0
				updatePrices = true;
				
				part_emitter_region(global._part_system, global._part_emitter_3, X,X+20,Y,Y+20, ps_shape_rectangle, ps_distr_linear)
				part_emitter_burst(global._part_system,global._part_emitter_3,global._part_type_14,25)
				part_emitter_burst(global._part_system,global._part_emitter_3,global._part_type_13,125)
			}
			
		}
		
		if lastHoveredUpgrade != boughtUpgrade then confirmPercent = 0
		
		var symbolCol = [ $8781f6,$b8ffe8,$fff10c]
		
		xRela = random_range(-shake[frameNumber],shake[frameNumber])
		yRela = random_range(-shake[frameNumber],shake[frameNumber])
		
		shake[frameNumber] = lerp(shake[frameNumber],0,0.05)
		
		draw_sprite(sUIUpgradeFrame,state+cursorInBox*4,X-1+round(xRela),Y-1+round(yRela))
		draw_sprite_ext(sUIUpgradeSymbols,symbol,X+4+round(xRela),Y+3+round(yRela),1,1,0,symbolCol[state-1],1)
		draw_sprite(sUIUpgradeCheckmark,state+cursorInBox*4,X-1+round(xRela),Y-1+round(yRela))
		if ID.newFrame then draw_sprite(sUIExclamationMark,1,X,Y-2+global.exMarkY);
		
		if confirmPercent > 0 and ID = boughtUpgrade {
		gpu_set_fog(true,c_white,0,1)
		draw_sprite_ext(sUIUpgradeFrame,state+cursorInBox*4,X-1,Y-1,1,1,0,c_white,round(confirmPercent*7.5)/7.5)
		draw_sprite_ext(sUIUpgradeSymbols,symbol,X+4,Y+3,1,1,0,symbolCol[state-1],round(confirmPercent*7.5)/7.5)
		draw_sprite_ext(sUIUpgradeCheckmark,state+cursorInBox*4,X-1,Y-1,1,1,0,c_white,round(confirmPercent*7.5)/7.5)
		gpu_set_fog(false,c_white,0,1)
		}
	}
}

updatePrices = false;

if !hoveringAnUpgrade {
	confirmPercent = 0
}

#region Currency Display
draw_set_font(global.fontAlagardGoldOutlined)
draw_set_halign(fa_middle)
draw_text(x+195,y+7,price_string(playerStats.money) + price_order(playerStats.money))
draw_set_halign(fa_left)
#endregion

#region Leave Button
var cursorInLeaveBox = cursor_in_box(x+12,y+36,x+30,y+62)
draw_sprite(sUILeaveButtonGeneral,cursorInLeaveBox,x+12,y+36)

if cursorInLeaveBox {
	cursor_skin(1)
	
	if mbLeft[PRESSED] then global.UIElementShowing = UI_NOTHING
}

#endregion

#region Particles
if !surface_exists(sf) then sf = surface_create(global.windowW,global.windowH)

surface_set_target(sf)
draw_clear_alpha(c_white,0)
part_system_drawit(global._part_system)
surface_reset_target()

//gpu_set_blendmode(bm_add)
draw_surface_part(sf,0,0,global.windowW-80,global.windowH,0,0)
//gpu_set_blendmode(bm_normal)


#endregion

part_system_automatic_draw(global._part_system,true)

showUpPrev = showUp;
}