function item_lock(item) {
	if item.locked then item.locked = false;
	else item.locked = true;
}