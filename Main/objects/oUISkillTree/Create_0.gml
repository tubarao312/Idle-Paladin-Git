event_inherited()

randomize()

//These constants determine how parallax works
bgLayerDistance = 1.5
cloudsLayerDistance = 2

squareWidth = sprite_get_width(sSpaceBG)
squareHeight = sprite_get_height(sSpaceBG)

cameraX = 1000
cameraY = 1000

shake_length = 0;
shake_remain = 0;
shake_magnitude = 0;

#region Surfaces and explanation

/* All the surfaces needed

NOTE - Background 1 and 2 don't need to be surfaces as they are not mutable

sfStars - There needs to be a surface for the upgrades that doesn't need to be cleared up 
and only gets updated whenever it is deemed necessary.

sfLines - The surface where lines are drawn. Gets updated every frame.

sfTooltips - The surface to which the tooltips are drawn. Gets updated every frame

*/

sfStars = surface_create(squareWidth,squareHeight)
sfStarsUpdate = false

sfLines = surface_create(squareWidth,squareHeight)
sfLinesUpdate = true

sfTooltips = surface_create(squareWidth,squareHeight)

sfFinal = surface_create(squareWidth,squareHeight)

sfFinalBG = surface_create(squareWidth,squareHeight)

sfAsteroids = surface_create(squareWidth,squareHeight);


surface_free(sfStars)
surface_free(sfLines)
surface_free(sfTooltips)
surface_free(sfFinal)
surface_free(sfFinalBG)
surface_free(sfAsteroids);
#endregion

grapplePointX = 0
grapplePointY = 0

cursorGrappling = false
cursorGrapplingPrev = false

cameraXPrev = cameraX
cameraYPrev = cameraY

cameraXRegisterSpd = 0
cameraYRegisterSpd = 0

cameraXSpd = 0
cameraYSpd = 0

cameraShake = 0

selectedStarActive = false //If the tooltip for this upgrade should be shown

UIAlpha = 0

cursorInTooltip = false