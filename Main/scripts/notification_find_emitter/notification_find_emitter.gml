function notification_find_emitter(emitter) { // Returns a list of notifications with an emitter
	var foundList = ds_list_create();
	
	var i; 
	for (i = ds_list_size(global.notificationList)-1; i >= 0; i--) {
		if global.notificationList[|i].emitter = emitter then ds_list_add(foundList, global.notificationList[|i]);
	}
	
	return foundList;
}