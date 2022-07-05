///Text Background Colour
///@arg x
///@arg y
///@arg text
///@arg color
///@arg THICK/THIN

#macro THICK true
#macro THIN false

function draw_text_outline(X, Y, text, col, mode) {
		
		draw_text_color(X+1, Y, text, col, col, col, col, 1)
		draw_text_color(X-1, Y, text, col, col, col, col, 1)
		draw_text_color(X, Y+1, text, col, col, col, col, 1)
		draw_text_color(X, Y-1, text, col, col, col, col, 1)

		if mode = true {
		draw_text_color(X+1, Y+1, text, col, col, col, col, 1)
		draw_text_color(X-1, Y-1, text, col, col, col, col, 1)
		draw_text_color(X-1, Y+1, text, col, col, col, col, 1)
		draw_text_color(X+1, Y-1, text, col, col, col, col, 1)
		}
}