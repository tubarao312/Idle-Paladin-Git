var shouldDraw = (yRel > -250);

if shouldDraw {
	if state = ACHIEVEMENT_UI_STATE.categories {
		draw_self();
	
		#region Draw Complete Achievements --------------------------------#
		var listSize = ds_list_size(global.achievementList);
		for (var i = 0; i < listSize; i++) {
			var X = x + 93 + (i%4 - 1) * 53;
			var Y = y + 48 + (floor(i/4)) * 36;
			var ach = global.achievementList[| i];
			var rank = ach.rank;
			var sprite = ach.sprite;
			var hovered = cursor_in_box(X,Y,X+43,Y+32);
		
			draw_sprite(sUIAchRankBackgrounds,rank,X,Y);
		
			if hovered {
				draw_sprite(sUIAchAchievementSelected,0,X,Y);
				if ach.rank > 0 cursor_skin(1);
				ach.imgSpd = 0.30;
			
				if mbLeft[PRESSED] and ach.rank > 0 {
					state = ACHIEVEMENT_UI_STATE.specific;
					selectedAchievement = ach;
				}
			}
		
			if rank > 0 { //Draw Icons
				var cols = [ $b9a192,$4fc55a,$dc9800,$f589f3,$3874e0,$5d55f5,$fa097a];
			
				ach.imgIndex += ach.imgSpd;
				ach.imgSpd = approach(ach.imgSpd,0,-0.003);
			
				if resetRotation or (ach.imgSpd < 0.25 and floor(ach.imgIndex) = 0) {
					ach.imgSpd = 0;
					ach.imgIndex = 0;
				}
			
				if ach.imgIndex > 8 then ach.imgIndex -= 8;
				
				gpu_set_fog(true,cols[rank-1],0,1);
				draw_sprite(sprite,ach.imgIndex,X+22,Y+17);
				draw_sprite(sprite,ach.imgIndex,X+23,Y+18);
				gpu_set_fog(false,c_white,0,1);
			
				draw_sprite(sprite,ach.imgIndex,X+21,Y+16)
			
				draw_sprite(sAchRanks,rank-1,X+44,Y+33);
			}
		}
		#endregion
	
		#region Draw Unmade Achievements ----------------------------------#
	
		while i < 12 {
			var X = x + 93 + (i%4 - 1) * 53;
			var Y = y + 48 + (floor(i/4)) * 36;
			draw_sprite(sUIAchRankBackgrounds,0,X,Y);
			var hovered = cursor_in_box(X,Y,X+43,Y+32);
			if hovered draw_sprite(sUIAchAchievementSelected,0,X,Y);
			i++;
		}
	
		#endregion
		
		if resetRotation then resetRotation = false;
	} 
	else if state = ACHIEVEMENT_UI_STATE.specific { //--------------------------------------------------------------------------------------
		draw_sprite(sprite_index,1,x,y);
		
		#region Drawing Bars, Names and Ranks ----------------------------#
		var rankFonts = [global.fontHopeWhite,global.fontHopeUncommon,global.fontHopeRare,global.fontHopeEpic,global.fontHopeLegendary,global.fontHopeFabled,global.fontHopeMythic]
		var rankLetters = ["F","E","D","C","B","A","S"];
		var achRank = selectedAchievement.rank;
		var achName = selectedAchievement.nam;
		
		//Name and Rank
		draw_set_font(rankFonts[achRank-1]);
		draw_set_halign(fa_middle);
		
		gpu_set_fog(true,$9fcaf6,0,1);
		draw_text(x+112,y+34,achName);
		draw_text(x+113,y+35,achName);
		draw_text(x+213,y+34,"Rank "+rankLetters[achRank-1]);
		draw_text(x+214,y+35,"Rank "+rankLetters[achRank-1]);
		gpu_set_fog(false,$9fcaf6,0,1);
		
		draw_text(x+111,y+33,achName);
		draw_text(x+212,y+33,"Rank "+rankLetters[achRank-1]);
		
		draw_set_halign(fa_left);
		
		//Bar
		draw_sprite(sUIAchRarityBars,achRank-1,x+39,y+41);
		#endregion
		#region Drawing Objectives ---------------------------------------#
		listSize = ds_list_size(selectedAchievement.objectiveList)
		
		for (i = 0; i < 6; i++) {
			var X = x+189;
			var Y = y+52+i*16;
			
			var selected = cursor_in_box(X,Y,X+48,Y+15)
			
			if selected draw_sprite(sUIAchObjectiveSelected,0,X,Y+1);
			
			if i < listSize {
				var obj = selectedAchievement.objectiveList[| i];
				var rank = obj.rank;
			
				if rank > 0 {
					var rankFonts = [global.fontHopeWhite,global.fontHopeUncommon,global.fontHopeRare,global.fontHopeEpic,global.fontHopeLegendary,global.fontHopeFabled,global.fontHopeMythic,global.fontHopeMythic];
					var shortName = obj.shortName;
					
					draw_sprite(sUIAchRarityCateg,rank-1,X,Y);
					draw_set_font(rankFonts[rank-1]);
					draw_set_halign(fa_middle);
					draw_text(X+23,Y+5,shortName);
					draw_set_halign(fa_left);
					
					if selected then selectedObjective = obj;
				
				}
			}
			
		}
		
		
		
		#endregion
		#region Back Button ----------------------------------------------#
		var cursorInLeaveBox = cursor_in_box(x+12,y+36+29,x+30,y+62+29)
		draw_sprite(sUIBackButtonGeneral,cursorInLeaveBox,x+12,y+36+29)

		if cursorInLeaveBox {
			cursor_skin(1)
	
			if mbLeft[PRESSED] {
				state = ACHIEVEMENT_UI_STATE.categories;
				resetRotation = true;
			}
		}

		#endregion
		#region Drawing objective descriptions ---------------------------#
		
		if selectedObjective != noone { //Selected Objective
			if keyboard_check(ord("T")) {
				global.objectiveArray[selectedObjective.statTrack] += 10
				update_player_stats();
			}
			
			draw_set_font(global.fontHopeBeja);
			draw_set_halign(fa_middle);
			
			// Name
			gpu_set_fog(true,$699ce6,0,1);
			draw_text(x+112,y+57,selectedObjective.longName);
			draw_text(x+113,y+58,selectedObjective.longName);
			gpu_set_fog(false,c_white,0,1);
			
			draw_text(x+111,y+56,selectedObjective.longName);
			
			// Description
			draw_set_font(global.fontSinsWhite);
			
			var previousScores = 0;
			if selectedObjective.rank > 1 and selectedObjective.rank < 7 for (i = 0; i < selectedObjective.rank-1; i++) {
				previousScores += selectedObjective.milestones[i];
			}

			if selectedObjective.rank < 7  then var str = dynstr_interpret(selectedObjective.dynDesc, [0,0,selectedObjective.milestones[selectedObjective.rank-1] + previousScores - global.objectiveArray[selectedObjective.statTrack]]);
			else str = "Maxed out!";
			
			gpu_set_fog(true,$699ce6,0,1);
			draw_text_ext(x + 113, y + 84, str, 13, 132);
			draw_text_ext(x + 114, y + 85, str, 13, 132);
			gpu_set_fog(false,c_white,0,1); 
			
			draw_text_ext(x + 112, y + 83, str, 13, 132);
			
			draw_set_halign(fa_left);
			
			if selectedObjective.rank < 7 then var spr = floor(11*((global.objectiveArray[selectedObjective.statTrack] - previousScores) / (selectedObjective.milestones[selectedObjective.rank-1])))
			else spr = 10;
			
			draw_sprite(sUIAchObjectiveProgressBar,spr,x+56,y+68);
			
			draw_sprite(sUIAchObjectiveSeparator,0,x+44,y+80);
			
		}
		
		#endregion
		#region Drawing upgrade rewards ----------------------------------#
		else {
			draw_sprite(sUIAchNextRank,0,x+76,y+52);
			draw_sprite(sUIAchObjectiveSeparator,0,x+44,y+66);
			draw_sprite(sUIAchObjectiveSeparator,0,x+44,y+66+55);
			
			
		}
		
		#endregion
		
		selectedObjective = noone;	
	}
		
	#region Leave Button ----------------------------------------------#
	var cursorInLeaveBox = cursor_in_box(x+12,y+36,x+30,y+62)
	draw_sprite(sUILeaveButtonGeneral,cursorInLeaveBox,x+12,y+36)

	if cursorInLeaveBox {
		cursor_skin(1)
	
		if mbLeft[PRESSED] then global.UIElementShowing = UI_NOTHING
	}

	#endregion
} else state = ACHIEVEMENT_UI_STATE.categories;

if !showUpPrev and showUp {
	alarm[0] = 1;
	rotatedFrames = 0;
}

showUpPrev = showUp;