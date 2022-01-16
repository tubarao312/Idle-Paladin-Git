draw_self()

var spriteToUse = [sHUDAbilitiesGrey,sHUDAbilitiesBlue]

draw_sprite(spriteToUse[abilityUnlocked[0]],0,x-26+xShake[0],y-4+yShake[0])
draw_sprite(spriteToUse[abilityUnlocked[1]],1,x+2+xShake[1],y-4+yShake[1])
draw_sprite(spriteToUse[abilityUnlocked[2]],2,x+30+xShake[2],y-4+yShake[2])
draw_sprite(spriteToUse[abilityUnlocked[3]],3,x+58+xShake[3],y-4+yShake[3])

abilityUnlocked[0] = (abilityCost[0] <= playerStats.mana)
abilityUnlocked[1] = (abilityCost[1] <= playerStats.mana)
abilityUnlocked[2] = (abilityCost[2] <= playerStats.mana)
abilityUnlocked[3] = (abilityCost[3] <= playerStats.mana)

var cursorInAbility
cursorInAbility[0] = cursor_in_box(x-25,y-3,x-1,y+21)
cursorInAbility[1] = cursor_in_box(x+3,y-3,x+27,y+21) * 2 
cursorInAbility[2] = cursor_in_box(x+31,y-3,x+55,y+21) * 3
cursorInAbility[3] = cursor_in_box(x+59,y-3,x+83,y+21) * 4

var abilitySelected = cursorInAbility[0] + cursorInAbility[1] + cursorInAbility[2] + cursorInAbility[3]

if abilitySelected > 0 {
	draw_sprite(sHUDAbilitiesOutline,0,x+(abilitySelected-1)*28-26+xShake[abilitySelected-1],y-4+yShake[abilitySelected-1])
	if abilityUnlocked[abilitySelected-1] {
		cursor_skin(1)
		ohudManaBar.manaReq = abilityCost[abilitySelected-1]
	
		if mbLeft[PRESSED] and ohudManaBar.manaReq <= playerStats.mana {
			abilityUsed = abilitySelected
			shake[abilitySelected-1] = 1
		}
		
	} else {
		ohudManaBar.manaReq = 0
	}
} else {
	ohudManaBar.manaReq = 0
}

var numberSpriteToUse = [sHUDAbilitiesCostGrey,sHUDAbilitiesCostBlue]

xShake[0] = round(random_range(-shake[0],shake[0]))
xShake[1] = round(random_range(-shake[1],shake[1]))
xShake[2] = round(random_range(-shake[2],shake[2]))
xShake[3] = round(random_range(-shake[3],shake[3]))

yShake[0] = round(random_range(-shake[0],shake[0]))
yShake[1] = round(random_range(-shake[1],shake[1]))
yShake[2] = round(random_range(-shake[2],shake[2]))
yShake[3] = round(random_range(-shake[3],shake[3]))

draw_sprite(numberSpriteToUse[abilityUnlocked[0]],abilityCost[0]-1 + (abilitySelected-1 = 0)*3,x-8+xShake[0],y+15+yShake[0])
draw_sprite(numberSpriteToUse[abilityUnlocked[1]],abilityCost[1]-1 + (abilitySelected-1 = 1)*3,x+20+xShake[1],y+15+yShake[1])
draw_sprite(numberSpriteToUse[abilityUnlocked[2]],abilityCost[2]-1 + (abilitySelected-1 = 2)*3,x+48+xShake[2],y+15+yShake[2])
draw_sprite(numberSpriteToUse[abilityUnlocked[3]],abilityCost[3]-1 + (abilitySelected-1 = 3)*3,x+76+xShake[3],y+15+yShake[3])

shake[0] = lerp(shake[0],0,0.05)
shake[1] = lerp(shake[1],0,0.05)
shake[2] = lerp(shake[2],0,0.05)
shake[3] = lerp(shake[3],0,0.05)

switch abilityUsed {
	case 1: {
		oPlayer.dashAlternateInput = true
	break; }
	case 2: {
		oPlayer.shieldAlternateInput = true;
		abilityUsed = 0;
	break;}
	case 4: {
		oPlayer.fireballAlternateInput = true;
		abilityUsed = 0;
	break;}
	
}

if global.UIElementShowing = UI_NOTHING and cursor_in_box(xSet-45,0,global.windowW,ySet+30) {
	global.UIElementShowing = UI_ABILITIES
} else if global.UIElementShowing = UI_ABILITIES and !cursor_in_box(xSet-45,0,global.windowW,ySet+30) {
	global.UIElementShowing = UI_NOTHING
}