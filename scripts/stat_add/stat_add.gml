function stat_add(itemInstance, statBP, quantity) {
	var stat = {};
	
	stat.quantity = quantity;
	stat.bp = statBP;
	
	ds_list_add(itemInstance.statList, stat);
	
	return stat;
}