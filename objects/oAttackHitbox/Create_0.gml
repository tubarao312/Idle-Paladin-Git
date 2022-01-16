hitEnemiesList = ds_list_create();
hitEnemiesThisFrameList = ds_list_create();

/* EXPLANATION FOR HITBOXES
	Hitboxes can be spawned through 'create_hitbox()'. After that,
	they'll create a list of enemies hit and then send a 'hit' struct
	to those enemies' 'hitsTaken' ds_list - As such, every enemy that
	is intended to get hit should have:
		create_hits_taken_list(); <- in its creation code.
		read_hits_taken_list(); <- in its step code.
	
	After that, the list will get ready every frame and each hit
	will have a different effect (this works by having a function
	inside each hit struct).
*/