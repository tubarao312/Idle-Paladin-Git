event_inherited()

itemSelectedIndicatorFrame = 0
alarm[0] = 1
itemSelectedIndicatorX = 0


selectedPage = 1
lastValidPage = 1

lastHoveredBox = 1
lastHoveredBoxPrevious = 1
lastHoveredBoxValid = 1


ogY = y

redrawThreeItems = true
sfThreeItems = surface_create(global.windowW,global.windowH)

redrawItemDesc = true
sfItemDesc = surface_create(global.windowW,global.windowH)

surface_free(sfThreeItems)

selectedItem = 0

updateSelectedPrice = true
selectedItemPriceNumber = 0
selectedPrices = [1,10,25,50]
changeButtonClicked = 0

showUp = false

sfParts = surface_create(global.windowW,global.windowH)