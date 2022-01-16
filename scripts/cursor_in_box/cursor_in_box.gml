///@arg X1
///@arg Y1
///@arg X2
///@arg Y2

function cursor_in_box(X1,Y1,X2,Y2){
	var inX = (global.cursorX >= X1 and global.cursorX <= X2) or (global.cursorX <= X1 and global.cursorX >= X2)
	var inY = (global.cursorY >= Y1 and global.cursorY <= Y2) or (global.cursorY <= Y1 and global.cursorY >= Y2)
	
	return inX and inY
}