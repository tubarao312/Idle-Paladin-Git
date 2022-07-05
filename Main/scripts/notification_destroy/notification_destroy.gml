function notification_destroy(notification) { // Destroys a notification in specific
	var foundIndex = ds_list_find_index(global.notificationList, notification)
	
	if foundIndex != -1 then ds_list_delete(global.notificationList, foundIndex);
}