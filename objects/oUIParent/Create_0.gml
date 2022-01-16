/// @desc Explanation Here

global.createdUI = true

/*
ANCHOR Variable: UI Element follows this anchor when the display gets scaled.
This variable ranges from 1 to 9:
 1 TOP_LEFT    | 2 TOP_CENTER    | 3 TOP_RIGHT
---------------+-----------------+----------------
 4 MIDDLE_LEFT | 5 MIDDLE_CENTER | 6 MIDDLE_RIGHT
---------------+-----------------+----------------
 7 BOTTOM_LEFT | 8 BOTTOM_CENTER | 9 BOTTOM_RIGHT
*/

var xAnchorArrayOG = [0, 0, 195, 390, 0,  195, 390, 0,   195, 390];
var yAnchorArrayOG = [0, 0, 0,   0,   90, 90,  90,  180, 180, 180];

/* 
The initial x and y positions of the UI element at 
room creation determine where it'll be.
*/

xCreate = x - xAnchorArrayOG[anchor];
yCreate = y - yAnchorArrayOG[anchor];

xSet = global.xAnchorArray[anchor] + xCreate;
ySet = global.yAnchorArray[anchor] + yCreate;

//The relative coordinates used to move shit within the UI
xRel = 0;
yRel = 0;

persistent = true;