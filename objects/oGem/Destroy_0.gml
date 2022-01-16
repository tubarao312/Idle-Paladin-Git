event_inherited()
	
var value = price_multiply(playerStats.cps,playerStats.gemCPSMulti)
	
playerStats.money = price_add(playerStats.money,PLUS,value)

floating_text(x + random_range(-5,5) - 5, y + random_range(-5,5), price_string(value) + price_order(value), global.fontSinsGold)

oUICurrencyDisplay.whiteAlpha = lerp(oUICurrencyDisplay.whiteAlpha,1,0.6)

