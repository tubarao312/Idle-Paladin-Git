function notification_find_flag(flag) { // Returns a list of notifications with a flag
	var foundList = ds_list_create();
	
	var i; 
	for (i = ds_list_size(global.notificationList)-1; i >= 0; i--) {
		if global.notificationList[|i].flag = flag then ds_list_add(foundList, global.notificationList[|i]);
	}
	
	return foundList;
}