function item_set_add_item(set, itemBP) {
	ds_list_add(set.itemList, itemBP);
	itemBP.set = set;
}