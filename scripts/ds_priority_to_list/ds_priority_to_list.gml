function ds_priority_to_list(queue) {
	var bufferQueue = ds_priority_create();
	var list = ds_list_create();
	ds_priority_copy(bufferQueue, queue);
	
	while (ds_priority_size(bufferQueue) > 0) {
		ds_list_add(list, ds_priority_find_max(bufferQueue));
		ds_priority_delete_max(bufferQueue);
	
	}
	
	ds_priority_destroy(bufferQueue);
	
	return list;
}