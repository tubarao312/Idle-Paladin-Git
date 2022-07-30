draw_set_alpha(alpha);
draw_set_font(font);
draw_text(x + random_range(-1, 1) * shake, y + random_range(-1, 1) * shake, text);
draw_set_alpha(1);