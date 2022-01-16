function notification_find_value(value) { // Returns a list of notifications with a value
	var foundList = ds_list_create();
	
	var i; 
	for (i = ds_list_size(global.notificationList)-1; i >= 0; i--) {
		if global.notificationList[|i].value = value then ds_list_add(foundList, global.notificationList[|i]);
	}
	
	return foundList;
}
