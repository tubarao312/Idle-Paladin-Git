
if place_meeting(x,y,enemy) {
	instance_place_list(x, y, enemy, hitEnemiesThisFrameList, true)
	
	var i;
	if ds_list_size(hitEnemiesThisFrameList) > 0 then for (i = ds_list_size(hitEnemiesThisFrameList)-1; i >= 0; i--) {
		if ds_list_find_index(hitEnemiesList, hitEnemiesThisFrameList[| i]) = -1 {
			ds_list_add(hitEnemiesList, hitEnemiesThisFrameList[| i]);
			ds_list_add(hitEnemiesThisFrameList[| i].hitsTaken, hitInformation);
		}
	}
	
	ds_list_clear(hitEnemiesThisFrameList)
}