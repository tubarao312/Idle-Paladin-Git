function inv_resource_transfer(sourceInventory, destInventory, itemBP, quantity) {
	inv_resource_add(sourceInventory, itemBP, (-1) * quantity);
	inv_resource_add(destInventory, itemBP, quantity);
}