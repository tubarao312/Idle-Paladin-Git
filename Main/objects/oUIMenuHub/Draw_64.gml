draw_self()

var cursorInItemShop = cursor_in_box(x+16,y+10,x+100,y+28)
var cursorInSkillTree = cursor_in_box(x+16,y+35,x+100,y+53)
var cursorInUpgrades = cursor_in_box(x+16,y+60,x+100,y+78)
var cursorInJobs = cursor_in_box(x+16,y+85,x+100,y+103)
var cursorInOptions = cursor_in_box(x+30,y+110,x+86,y+128)

draw_sprite(sUIMenuButtons,5,x,y)
draw_sprite(sUIMenuButtons,0+cursorInItemShop*6,x,y)
if exMark[0] then draw_sprite(sUIExclamationMark,0,x+15,y+7+global.exMarkY)

draw_sprite(sUIMenuButtons,1+cursorInSkillTree*6,x,y)
if exMark[1] then draw_sprite(sUIExclamationMark,0,x+15,y+32+global.exMarkY)

draw_sprite(sUIMenuButtons,2+cursorInUpgrades*6,x,y)
if exMark[2] then draw_sprite(sUIExclamationMark,0,x+15,y+57+global.exMarkY)

draw_sprite(sUIMenuButtons,3+cursorInJobs*6,x,y)
if exMark[3] then draw_sprite(sUIExclamationMark,0,x+15,y+82+global.exMarkY)

draw_sprite(sUIMenuButtons,4+cursorInOptions*6,x,y)

if cursorInItemShop or cursorInSkillTree or cursorInUpgrades or cursorInJobs or cursorInOptions {
	cursor_skin(1)
	
	if mbLeft[PRESSED] {
		if cursorInItemShop {
			showUp = false
			oUIItemShop.showUp = true;
			oUIItemShop.redrawItemDesc = true;
			oUIItemShop.redrawThreeItems = true;

			global.UIElementShowing = UI_ITEMSHOP
			exMark[0] = false;
			
		} else if cursorInSkillTree {
			showUp = false
			oUISkillTree.showUp = true
			global.UIElementShowing = UI_SKILLTREE
			exMark[1] = false;
		
		} else if cursorInUpgrades {
			showUp = false
			oUIUpgradeShop.showUp = true
			oUIUpgradeShop.renewShownList = true
			
			global.UIElementShowing = UI_UPGRADESHOP
			exMark[2]= false;
		} else if cursorInJobs {
			showUp = false;
			oUIAchievements.showUp = true;
			
			global.UIElementShowing = UI_QUESTBOOK;
		}
	}
}