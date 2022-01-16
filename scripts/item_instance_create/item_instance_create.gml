function item_instance_create(bpName, level){
	var item = {};
	
	item.statList = ds_list_create();
	item.perkList = ds_list_create();
	item.bp = global.itemBlueprintMap[?bpName];
	item.level = level;
	item.newlyAcquired = true;
	item.currentInventory = noone;
	item.locked = false;
	item.equippedCharacter = noone;
	
	return item;
}