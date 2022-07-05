function notification_send(flag, value) { // Sends a notification
	var notification = {}
	notification.flag = flag;
	notification.value = value;
	notification.emitter = self;

	ds_list_add(global.notificationList);
}