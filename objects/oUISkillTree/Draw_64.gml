
#region Controlling tthe Alpha of the UI Part
if global.UIElementShowing = UI_SKILLTREE {
	UIAlpha = lerp(UIAlpha,1,0.08)
	if UIAlpha > 0.95 then UIAlpha = 1

} else {
	UIAlpha = lerp(UIAlpha,-1,0.08)
	if UIAlpha < -0.95 then UIAlpha = 0

}
#endregion

// System initialization code
part_system_automatic_draw(global._part_system,false);

if UIAlpha > 0 then {
cameraX += round(random_range(-shake_remain, shake_remain))
cameraY += round(random_range(-shake_remain, shake_remain))
shake_remain = round(max(0, shake_remain - ((1 / shake_length) * shake_magnitude)))

//Getting all the upgrade IDs that should be drawn on the screen
#region For Upgrades
var upgradesToDraw = upgrade_get_in_area(cameraX-100,cameraY-100,cameraX+global.windowW+100,cameraY+global.windowH+100)

var i
for (i = ds_list_size(global.stUpgradeShownList) - 1; i >= 0; i--) {
	if ds_list_find_index(upgradesToDraw,global.stUpgradeShownList[| i]) = -1 then upgrade_set_seen(global.stUpgradeShownList[| i],false)
}
#endregion

#region For Asteroids
var asteroidsToDraw = upgrade_get_asteroids_in_area(cameraX-100,cameraY-100,cameraX+global.windowW+100,cameraY+global.windowH+100)

#endregion

//If the cursor is inside the leave button
var cursorInLeaveButton = UIAlpha > 0.95 and cursor_in_box(global.windowW-10,global.windowH-10,global.windowW-45,global.windowH-45)

#region Asteroids

if !surface_exists(sfAsteroids) then sfAsteroids = surface_create(squareWidth,squareHeight);

surface_set_target(sfAsteroids);
draw_clear_alpha(c_white,0);

var i;
for (i = ds_list_size(asteroidsToDraw)-1; i >= 0; i --) {
	var ast = asteroidsToDraw[| i];
	
	var swingDistance = wave(-1,1,ast.swingSpd,0) * ast.swingDistance;
	var swingX = swingDistance * dcos(ast.swingDir);
	var swingY = swingDistance * dsin(ast.swingDir);
	
	var fearAngle,fearDistance,fearDistanceNew = 0;
	
	fearDistance = point_distance(ast.ogX+swingX,ast.ogY+swingY,global.cursorX+cameraX,global.cursorY+cameraY)
	
	if fearDistance < 25 {
		fearAngle = point_direction(ast.ogX+swingX,ast.ogY+swingY,global.cursorX+cameraX,global.cursorY+cameraY)
		
		fearDistance = 25-fearDistance;
		fearDistanceNew = ast.cursorResponsiveness * (1 - 1/(fearDistance+1))
		
		ast.fearX = lerp(ast.fearX,-dcos(fearAngle) * fearDistanceNew,0.1);
		ast.fearY = lerp(ast.fearY,dsin(fearAngle) * fearDistanceNew,0.1);
		
	} else {
		ast.fearX = lerp(ast.fearX,0,0.05);
		ast.fearY = lerp(ast.fearY,0,0.05);
	
	
	}
	
	draw_sprite(sUISkillTreeAsteroid,ast.image, ast.ogX+swingX+ast.fearX, ast.ogY+swingY+ast.fearY);
		
}

surface_reset_target();

#endregion

#region Stars
/*###########################################################################################
sfStars - There needs to be a surface for the upgrades that doesn't need to be cleared up	#
and only gets updated whenever it is deemed necessary.										#
#############################################################################################*/

if !surface_exists(sfStars) or sfStarsUpdate {
	if !surface_exists(sfStars) then sfStars = surface_create(squareWidth,squareHeight)
	sfStarsUpdate = false

	surface_set_target(sfStars)
	
	draw_clear_alpha(c_white,0)
	
	var i
	for (i = ds_list_size(global.stUpgradeList) - 1; i >= 0; i--) {
		var ID = global.stUpgradeList[| i]
		var state = upgrade_get_state(ID)
		var X = upgrade_get_x(ID)
		var Y = upgrade_get_y(ID)
		var cost = upgrade_get_cost(ID)
		
		var STAR_SPRITE_ARRAY = [sRedStar,sGreenStar,sBlueStar]
		if state > 0 {
			if state < 3 and cost <= playerStats.skillPoints {
				upgrade_set_state(ID,2)
				state = 2
			}
			else if state < 3 {
				upgrade_set_state(ID,1)
				state = 1
			}
			draw_sprite(STAR_SPRITE_ARRAY[state-1],0,X,Y)	
		}
	}
	
	surface_reset_target()
}


#region Lines ----------------------------------------------------------------------------

cursorInAStar = false //If the stars should keep looking for the cursor

if !surface_exists(sfLines) or sfLinesUpdate {
	if !surface_exists(sfLines) then sfLines = surface_create(squareWidth,squareHeight)
	sfLinesUpdate = false
	
	surface_set_target(sfLines)
	
	draw_clear_alpha(c_white,0)
	
	var i,j
	for (i = ds_list_size(upgradesToDraw) - 1; i >= 0; i --) {
		var ID = upgradesToDraw[| i]
		var seen = upgrade_get_seen(ID)
		var state = upgrade_get_state(ID)
		
		var selected = !selectedStarActive and !cursorInLeaveButton and !cursorInAStar and point_distance(ID.X,ID.Y,global.cursorX+cameraX,global.cursorY+cameraY) < 15
	
		if selected {
			cursorInAStar = true
			selectedStar = ID 
		}
		
		if !seen { //Assigning all the points coordinates
			var numberOfCorners = ceil(random_range(2,4.9))*2
			var degreesBetweenCorners = 360/numberOfCorners
			ID.cornersInfo = ds_list_create() //All the points surrounding the upgrade
			ID.randomizedCorner = ceil(random_range(-0.9,numberOfCorners-0.1))
			ID.randomizedCornerDist = random_range(-3,3)
			upgrade_set_seen(ID,true)
			
			for (j = 0; j < numberOfCorners; j ++) {
				var corner = {}
				corner.angle = degreesBetweenCorners*j + random_range(-3,3) //The angle for each point
				corner.angleTimerOffset = random_range(-0.5,0.5)
				
				corner.ogDistanceWaveDuration = random_range(8,14)
				corner.ogDistanceOffset = random_range(-3,3)
				corner.ogDistanceMax = 27
				corner.ogDistanceMin = 18
				
				corner.circleAngle = random_range(0,360)
				corner.circleAngleSpd = random_range(-1,1)
				corner.circleRadius = random_range(1,2)
				
				ds_list_add(ID.cornersInfo,corner)
			}			
			
			#region Connecting Lines
			var dad = upgrade_get_parent(ID)
			
			if dad != noone {
				ID.connecter1 = {}
				ID.connecter1.ogX = upgrade_get_x(ID) * 0.66 + upgrade_get_x(dad) * 0.33 + random_range(-5,5)
				ID.connecter1.ogY = upgrade_get_y(ID) * 0.66 + upgrade_get_y(dad) * 0.33 + random_range(-5,5)
				ID.connecter1.angleDistance = random_range(10,15) / 2
				ID.connecter1.angleDuration = random_range(10,13) * 2 
			
				ID.connecter2 = {}
				ID.connecter2.ogX = upgrade_get_x(ID) * 0.33 + upgrade_get_x(dad) * 0.66 + random_range(-5,5)
				ID.connecter2.ogY = upgrade_get_y(ID) * 0.33 + upgrade_get_y(dad) * 0.66 + random_range(-5,5)
				ID.connecter2.angleDistance = random_range(10,15) / 2
				ID.connecter2.angleDuration = random_range(10,13) * 2
			}
			#endregion
		}
	
		//Randomizing one of the points
		if !selected and chance(0.015) {
			ID.randomizedCorner = ceil(random_range(-0.9,ds_list_size(ID.cornersInfo)-0.1))
			ID.randomizedCornerDist = random_range(-3,3)
		}
		
		if seen {
			#region Information Assignemnt (Coordinates, etc...)
			
			#region Connecters
			if upgrade_get_parent(ID) != noone {
				ID.connecter1.X = ID.connecter1.ogX + dcos(wave(0,360,ID.connecter1.angleDuration,0)) * ID.connecter1.angleDistance * wave(0.25,1,5,0)
				ID.connecter1.Y = ID.connecter1.ogY + dsin(wave(0,360,ID.connecter1.angleDuration,0)) * ID.connecter1.angleDistance * wave(0.25,1,4.5,0)
			
				ID.connecter2.X = ID.connecter2.ogX + dcos(wave(0,360,ID.connecter1.angleDuration,0)) * ID.connecter1.angleDistance * wave(0.25,1,4,0) 
				ID.connecter2.Y = ID.connecter2.ogY + dsin(wave(0,360,ID.connecter1.angleDuration,0)) * ID.connecter1.angleDistance * wave(0.25,1,3,0)
			}
			
			#endregion
			
			#region Corners
			for (j = ds_list_size(ID.cornersInfo) - 1; j >= 0; j --) {
				var corner = ID.cornersInfo[| j]
				
				if j = ID.randomizedCorner then corner.ogDistanceOffset = lerp(corner.ogDistanceOffset,ID.randomizedCornerDist,0.2)
				
				
				if selected {
					corner.ogDistanceMin = lerp(corner.ogDistanceMin,31,0.3)
					corner.ogDistanceMax = lerp(corner.ogDistanceMax,31,0.3)
					cursor_skin(1)
					
				} else {
					corner.ogDistanceMin = lerp(corner.ogDistanceMin,18,0.3)
					corner.ogDistanceMax = lerp(corner.ogDistanceMax,27,0.3)
				}
				
				//Calculating the ogX and ogY coordinates
				corner.ogDistance = wave(corner.ogDistanceMin,corner.ogDistanceMax,corner.ogDistanceWaveDuration,0) + 2
				corner.angle += wave(-0.2,0.2,10+corner.angleTimerOffset,random_range(0,360))
				corner.circleAngle += corner.circleAngleSpd
			
				if corner.circleAngle > 360 then corner.circleAngle -= 360
				else if corner.circleAngle < 0 then corner.circleAngle += 360
				
				corner.ogX = upgrade_get_x(ID) + dcos(corner.angle) * (corner.ogDistance)*1.15 //max(corner.ogDistance+corner.ogDistanceOffset,20) 
				corner.ogY = upgrade_get_y(ID) + dsin(corner.angle) * (corner.ogDistance)*1.15 //max(corner.ogDistance+corner.ogDistanceOffset,20) 
				
				corner.X = corner.ogX + dcos(corner.circleAngle) * corner.circleRadius * 0
				corner.Y = corner.ogY + dsin(corner.circleAngle) * corner.circleRadius * 0
			}
			
			#endregion
			#endregion
			var lineDir = 1
			var CLINE_SPRITE_ARRAY = [sClineRedDark,sClineGreenDark,sClineBlueDark,sClineRedLight,sClineGreenLight,sClineBlueLight]
			
			#region Information Reading and Drawing
			
			#region Connecters
			
			var MIDDLE_SPRITE_ARRAY = [sClineBlueToRed,sClineBlueToGreen,sClineBlueToBlue]
			var BEGINNING_SPRITE_ARRAY = [sClineRedAll,sClineGreenAll,sClineBlueAll]
			
			if upgrade_get_parent(ID) != noone {
				draw_cline(ID.X,ID.Y,ID.connecter1.X,ID.connecter1.Y,BEGINNING_SPRITE_ARRAY[upgrade_get_state(ID) - 1])
				draw_cline(ID.connecter1.X,ID.connecter1.Y,ID.connecter2.X,ID.connecter2.Y,MIDDLE_SPRITE_ARRAY[upgrade_get_state(ID) - 1])
				draw_cline(ID.dad.X,ID.dad.Y,ID.connecter2.X,ID.connecter2.Y,BEGINNING_SPRITE_ARRAY[upgrade_get_state(upgrade_get_parent(ID)) - 1])
			}
			#endregion
			
			#region Corners
			
			for (j = ds_list_size(ID.cornersInfo) - 1; j > 0; j --) {
				var corner = ID.cornersInfo[| j]
				var nextCorner = ID.cornersInfo[| j - 1]
				
				switch lineDir {
					case 1: {
						draw_cline(corner.X,corner.Y,nextCorner.X,nextCorner.Y,CLINE_SPRITE_ARRAY[state-1 + selected*3])
						break
					}
					case -1: {
						draw_cline(nextCorner.X,nextCorner.Y,corner.X,corner.Y,CLINE_SPRITE_ARRAY[state-1 + selected*3])
						break
					}
				}
				lineDir *= -1
			}
			
			draw_cline( //A final line must be drawn between the final and beginning element of the list
			ID.cornersInfo[| ds_list_size(ID.cornersInfo) - 1].X,
			ID.cornersInfo[| ds_list_size(ID.cornersInfo) - 1].Y,
			ID.cornersInfo[| 0].X, 
			ID.cornersInfo[| 0].Y,
			CLINE_SPRITE_ARRAY[state-1 + selected*3])
			
			
			#endregion
			
			#region Random Particles
			
			if chance(0.7) {
				switch state { //Switching between particle colors
					case 2: {
						part_emitter_region(global._part_system, global._part_emitter_3, ID.X+0.5,ID.X+0.5,ID.Y+0.5,ID.Y+0.5, ps_shape_ellipse, ps_distr_linear)
						part_emitter_burst(global._part_system,global._part_emitter_3,global._part_type_5,1)
						break;
					}
					case 1: {
						part_emitter_region(global._part_system, global._part_emitter_3, ID.X+0.5,ID.X+0.5,ID.Y+0.5,ID.Y+0.5, ps_shape_ellipse, ps_distr_linear)
						part_emitter_burst(global._part_system,global._part_emitter_3,global._part_type_6,1)
						break;
					}
					case 3: {
						part_emitter_region(global._part_system, global._part_emitter_3, ID.X+0.5,ID.X+0.5,ID.Y+0.5,ID.Y+0.5, ps_shape_ellipse, ps_distr_linear)
						part_emitter_burst(global._part_system,global._part_emitter_3,global._part_type_4,1)
						break;
					}
				}
				
				
			}
			
			#endregion
			
			#endregion
		
		}	
	}
	
	surface_reset_target()
}

#endregion

#region Tooltips -------------------------------------------------------------------------

if selectedStarActive {
	var X = upgrade_get_x(openedStar)
	var Y = upgrade_get_y(openedStar)
	
	if !surface_exists(sfTooltips) then sfTooltips = surface_create(squareWidth,squareHeight)
	
	surface_set_target(sfTooltips)
	
	draw_clear_alpha(c_white,0)
	
	var TOOLTIP_ARRAY = [sSpaceRedTooltip,sSpaceGreenTooltip,sSpaceBlueTooltip]
	var state = upgrade_get_state(openedStar)
	
	draw_sprite_ext(TOOLTIP_ARRAY[state-1],cursorInTooltip,X,Y,selectedStarAlpha,selectedStarAlpha,0,c_white,selectedStarAlpha)
	
	
	if state = 2 and selectedStarAlpha > 0.98 {
		gpu_set_colorwriteenable(1,1,1,0);
		draw_sprite_part_ext(sSpaceConfirmBuy,0,0,0,floor(69*selectedStarPercentage/1.5)*1.5,11,X-34,Y-14,1,1,c_white,selectedStarPercentage+0.5);
		gpu_set_colorwriteenable(1,1,1,1);
	}
	selectedStarAlpha = lerp(selectedStarAlpha,1,0.15)
	
	if selectedStarAlpha > 0.98 then selectedStarAlphaText = lerp(selectedStarAlphaText,1,0.15)
	
	if state = 2 and selectedStarAlpha > 0.98 {
		var boxUpperX = X-cameraX-77
		var boxUpperY = Y-cameraY-111
		
		var boxDownX = boxUpperX + 77 + 76
		var boxDownY = boxUpperY + 119
		
		if cursor_in_box(boxUpperX,boxUpperY,boxDownX,boxDownY) then cursorInTooltip = true
		else cursorInTooltip = false
	} else {
		cursorInTooltip = false
	}

	if cursorInTooltip {
		cursor_skin(1)
	
		if mbLeft[HELD] {
			selectedStarPercentage += 0.01
			part_emitter_region(global._part_system, global._part_emitter_3, openedStar.X+0.5,openedStar.X+0.5,openedStar.Y+0.5,openedStar.Y+0.5, ps_shape_ellipse, ps_distr_linear)
			part_emitter_burst(global._part_system,global._part_emitter_3,global._part_type_10,max(1,ceil(selectedStarPercentage*7)))
			
			
		} else selectedStarPercentage = lerp(selectedStarPercentage,0,0.1)
	} else {
		selectedStarPercentage = lerp(selectedStarPercentage,0,0.1)
	}
	
	var FONT_TO_USE = [global.fontMarskmanSpaceRed,global.fontMarskmanSpaceGreen,global.fontMarskmanSpaceBlue];
	var name = upgrade_get_name(openedStar)
	
	draw_set_font(FONT_TO_USE[state-1])
	draw_text_ext_color(X-68,Y-109,name,3,136,c_white,c_white,c_white,c_white,selectedStarAlphaText)
	
	var desc = upgrade_get_desc(openedStar)
	
	var FONT_TO_USE = [global.fontSinsSpaceRed,global.fontSinsSpaceGreen,global.fontSinsSpaceBlue];
	draw_set_font(FONT_TO_USE[state-1])
	draw_text_ext_color(X-67,Y-89,desc,12,136,c_white,c_white,c_white,c_white,selectedStarAlphaText)
	
	var cost = upgrade_get_cost(openedStar)
	
	
	if state != 3 {
		var FONT_TO_USE = [global.fontSpaceRedXP,global.fontSpaceGreenXP]
		draw_set_font(FONT_TO_USE[state-1]);

		draw_set_halign(fa_right);
		draw_text_colour(X+71,Y-99,string(cost) + "xp",c_white,c_white,c_white,c_white,selectedStarAlphaText);
		draw_set_halign(fa_left);
		
	}
	
	
	if selectedStarPercentage >= 1 then {
		upgrade_buy(selectedStar)
		selectedStarActive = 0
		cursorInTooltip = false
		sfStarsUpdate = true
		playerStats.skillPoints -= selectedStar.cost
		sfStarsUpdate = true
		
		screenshake_skilltree(6,5);
		
		part_emitter_region(global._part_system, global._part_emitter_3, selectedStar.X+0.5-5,selectedStar.X+0.5+5,selectedStar.Y+0.5-5,selectedStar.Y+0.5+5, ps_shape_ellipse, ps_distr_linear)
		part_emitter_burst(global._part_system,global._part_emitter_3,global._part_type_7,75)
		part_emitter_region(global._part_system, global._part_emitter_3, openedStar.X+0.5,openedStar.X+0.5,openedStar.Y+0.5,openedStar.Y+0.5, ps_shape_ellipse, ps_distr_linear)
		part_emitter_burst(global._part_system,global._part_emitter_3,global._part_type_4,600)
		part_emitter_region(global._part_system, global._part_emitter_3, openedStar.X+0.5,openedStar.X+0.5,openedStar.Y+0.5,openedStar.Y+0.5, ps_shape_ellipse, ps_distr_linear)
		part_emitter_burst(global._part_system,global._part_emitter_3,global._part_type_8,1200)
	}
	
	surface_reset_target()
} else {
	if !surface_exists(sfTooltips) then sfTooltips = surface_create(squareWidth,squareHeight)
	
	surface_set_target(sfTooltips)
	
	draw_clear_alpha(c_white,0)
	
	surface_reset_target()
}

#endregion 

#region Camera and Inputs
if mbLeft[PRESSED] and cursorInAStar and !cursorInTooltip then {
	grapplePointX = upgrade_get_x(selectedStar) - global.windowW/2
	grapplePointY = upgrade_get_y(selectedStar) - global.windowH/2 - 45

	selectedStarActive = true
	openedStar = selectedStar
	selectedStarAlpha = 0
	selectedStarAlphaText = 0
	selectedStarPercentage = 0

	switch openedStar.state { //Switching between particle colors
					case 2: {
						part_emitter_region(global._part_system, global._part_emitter_3, openedStar.X+0.5,openedStar.X+0.5,openedStar.Y+0.5,openedStar.Y+0.5, ps_shape_ellipse, ps_distr_linear)
						part_emitter_burst(global._part_system,global._part_emitter_3,global._part_type_5,600)
						break;
					}
					case 1: {
						part_emitter_region(global._part_system, global._part_emitter_3, openedStar.X+0.5,openedStar.X+0.5,openedStar.Y+0.5,openedStar.Y+0.5, ps_shape_ellipse, ps_distr_linear)
						part_emitter_burst(global._part_system,global._part_emitter_3,global._part_type_6,600)
						break;
					}
					case 3: {
						part_emitter_region(global._part_system, global._part_emitter_3, openedStar.X+0.5,openedStar.X+0.5,openedStar.Y+0.5,openedStar.Y+0.5, ps_shape_ellipse, ps_distr_linear)
						part_emitter_burst(global._part_system,global._part_emitter_3,global._part_type_4,600)
						break;
					}
				}
	
} else if mbLeft[PRESSED] and !cursorInAStar and !cursorInTooltip {
	grapplePointX = 0
	grapplePointY = 0

	cursorGrapplePointX = global.cursorX
	cursorGrapplePointY = global.cursorY
	ogCameraX = cameraX
	ogCameraY = cameraY
	
	cameraXSpd = 0
	cameraYSpd = 0
	
	cursorGrappling = true

	selectedStarActive = false

	
}

if cursorGrappling {
	if !mbLeft[HELD] then cursorGrappling = false
	
	cameraX = ogCameraX + cursorGrapplePointX - global.cursorX
	cameraY = ogCameraY + cursorGrapplePointY - global.cursorY
	
	#region Leaving grapple
	if abs(cameraX-cameraXPrev) >= abs(cameraXRegisterSpd) or sign(cameraX-cameraXPrev) != sign(cameraXRegisterSpd) {
		alarm[0] = 3
		cameraXRegisterSpd = cameraX-cameraXPrev
	}
	
	if abs(cameraY-cameraYPrev) >= abs(cameraYRegisterSpd) or sign(cameraY-cameraYPrev) != sign(cameraYRegisterSpd) {
		alarm[1] = 3
		cameraYRegisterSpd = cameraY-cameraYPrev
	}
	
	cameraXPrev = cameraX
	cameraYPrev = cameraY
	
	#endregion
	
	cursor_skin(1)
}

if cursorGrapplingPrev > cursorGrappling {
	cameraXSpd = sqrt(abs(cameraXRegisterSpd)) * sign(cameraXRegisterSpd)
	cameraYSpd = sqrt(abs(cameraYRegisterSpd)) * sign(cameraYRegisterSpd)
}

var cursorInUpperBox = window_has_focus() and cursor_in_box(0,0,global.windowW,10)
var cursorInLowerBox = window_has_focus() and cursor_in_box(0,global.windowH,global.windowW,global.windowH-10)

var cursorInLeftBox = window_has_focus() and cursor_in_box(0,0,10,global.windowH)
var cursorInRightBox = window_has_focus() and cursor_in_box(global.windowW,0,global.windowW-10,global.windowH)

cameraXSpd = lerp(cameraXSpd,0,0.1)
cameraYSpd = lerp(cameraYSpd,0,0.1)

cursorGrapplingPrev = cursorGrappling

cameraX += cameraXSpd - (cursorInLeftBox-cursorInRightBox)*1.5
cameraY += cameraYSpd - (cursorInUpperBox-cursorInLowerBox)*1.5

if grapplePointX != 0 then cameraX = ceil(lerp(cameraX,grapplePointX,0.1))
if grapplePointY != 0 then cameraY = ceil(lerp(cameraY,grapplePointY,0.1))

cameraX = max(0,cameraX)
cameraY = max(0,cameraY)
cameraX = min(squareWidth-global.windowW,cameraX)
cameraY = min(squareHeight-global.windowH,cameraY)

#endregion

#region Targeting the final surface that is then drawn on screen
#region Drawing the background layer
//Space Background
if !surface_exists(sfFinalBG) then sfFinalBG = surface_create(squareWidth,squareHeight)
surface_set_target(sfFinalBG)

//Background
draw_sprite(sSpaceBG,0,round(cameraX/bgLayerDistance)-500,round(cameraY/bgLayerDistance)-500)
//Clouds Background
draw_sprite(sSpaceBGClouds,0,round(cameraX/cloudsLayerDistance)-500,round(cameraY/cloudsLayerDistance)-500)

draw_surface_part(sfStars,floor(cameraX),floor(cameraY),global.windowW,global.windowH,floor(cameraX),floor(cameraY))

draw_surface_part(sfAsteroids,floor(cameraX),floor(cameraY),global.windowW,global.windowH,floor(cameraX),floor(cameraY))

part_system_drawit(global._part_system)

surface_reset_target()
#endregion

if !surface_exists(sfFinal) then sfFinal = surface_create(global.windowW,global.windowH)

surface_set_target(sfFinal)

//Drawing backround & Particles
draw_surface_part(sfFinalBG,cameraX,cameraY,global.windowW,global.windowH,0,0)

//The stars themselves
//draw_surface_part(sfStars,floor(cameraX),floor(cameraY),global.windowW,global.windowH,0,0)

//The lines that connect stars and surround them
if surface_exists(sfLines) then draw_surface_part(sfLines,floor(cameraX),floor(cameraY),global.windowW,global.windowH,0,0)
sfLinesUpdate = true

#endregion

if cursorInLeaveButton { //Leaving the Skill Tree
	cursor_skin(1)
	if mbLeft[PRESSED] then global.UIElementShowing = UI_NOTHING
}

surface_reset_target()
draw_surface_ext(sfFinal,0,0,1,1,0,c_white,UIAlpha)

//Tooltips
if UIAlpha > 0 and selectedStarActive and surface_exists(sfTooltips) {
	gpu_set_colorwriteenable(1,1,1,0)
	
	draw_surface_part_ext(sfTooltips,floor(cameraX),floor(cameraY),global.windowW,global.windowH,0,0,1,1,c_white,UIAlpha);
	
	gpu_set_colorwriteenable(1,1,1,1)
}

if UIAlpha > 0 {
	draw_sprite_ext(sSpaceLeaveButton,cursorInLeaveButton,global.windowW-10,global.windowH-10,1,1,0,c_white,UIAlpha)
	draw_set_font(global.fontMarskmanSpaceGreenXP);
	draw_set_halign(fa_right);
	draw_text(global.windowW-10,5,string(playerStats.skillPoints) + "xp");
	draw_set_halign(fa_left);
}

#endregion

} else { //Resetting all of the visuals
	for (i = ds_list_size(global.stUpgradeShownList) - 1; i >= 0; i--) {
		upgrade_set_seen(global.stUpgradeShownList[| i],false)
	}
}



// System initialization code
part_system_automatic_draw(global._part_system,true);












