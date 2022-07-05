function inv_resource_check_quantity(inventory, itemBP) {
	var value = inventory.itemMap[? itemBP];
	
	return is_undefined(value) ? 0 : value;
}