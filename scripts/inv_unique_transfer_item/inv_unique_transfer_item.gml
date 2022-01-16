function inv_unique_transfer_item(item, from, to) {
	inv_unique_remove_item(item, from);
	inv_unique_add_item(item, to);
}