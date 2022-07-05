if global.UIElementShowing != UI_UPGRADESHOP and global.UIElementShowing != UI_ITEMSHOP and global.UIElementShowing != UI_QUESTBOOK {

	draw_set_font(global.fontAlagardGoldOutlined)
	draw_set_halign(fa_center)
	draw_text(x,y,currencyString)
	draw_set_halign(fa_left)
	
	draw_sprite(sUICoinLine,0,x-24,y+16)

	if whiteAlpha > 0 {
		gpu_set_blendmode(bm_normal)
		gpu_set_fog(true,c_white,0,1)
		draw_set_alpha(round(whiteAlpha*5)/5)
		draw_set_halign(fa_center)
		draw_text(x,y,currencyString)
		draw_sprite(sUICoinLine,0,x-24,y+16)
		draw_set_halign(fa_left)
		gpu_set_fog(false,c_white,0,1)
		draw_set_alpha(1)
		gpu_set_blendmode(bm_normal)
		
		whiteAlpha -= 0.1
	}

	
}