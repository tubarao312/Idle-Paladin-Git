draw_sprite(sCursor, cursorSkin, global.cursorX, global.cursorY);

draw_set_font(global.fontHopeCommon);

draw_set_font(global.fontSinsCommon);

part_draw_hud_add();
part_draw_hud_normal();

with oRoomTransitioner room_draw_transition();
