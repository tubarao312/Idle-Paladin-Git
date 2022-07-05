///@arg X
///@arg Y
///@arg HPBAR_SMALL/MEDIUM/BIG
///@arg red 0-100
///@arg yellow 0-100

#macro HPBAR_SMALL	0
#macro HPBAR_MEDIUM 1
#macro HPBAR_BIG	2


function draw_hpbar(X, Y, size, redPercentage, yellowPercentage) {
	switch size {
		case HPBAR_SMALL: {
			draw_sprite(sEnemyHPBarBackground,size,X,Y);
			draw_sprite_part(sEnemyHPBarYellow, size, 1, 1, ceil(29*(yellowPercentage/100)),	10, X+1, Y+1);
			draw_sprite_part(sEnemyHPBarRed, size, 1, 1,	ceil(29*(redPercentage	/100)),		10, X+1, Y+1);
		break; }
		
		case HPBAR_MEDIUM: {
			draw_sprite(sEnemyHPBarBackground,size,X,Y);
			draw_sprite_part(sEnemyHPBarYellow, size, 1, 1, ceil(39*(yellowPercentage/100)),	10, X+1, Y+1);
			draw_sprite_part(sEnemyHPBarRed, size, 1, 1,	ceil(39*(redPercentage	/100)),		10, X+1, Y+1);
		break; }
		
		case HPBAR_BIG: {
			draw_sprite(sEnemyHPBarBackground,size,X,Y);
			draw_sprite_part(sEnemyHPBarYellow, size, 1, 1, ceil(49*(yellowPercentage/100)),	10, X+1, Y+1);
			draw_sprite_part(sEnemyHPBarRed, size, 1, 1,	ceil(49*(redPercentage	/100)),		10, X+1, Y+1);
		break; }
	}
}