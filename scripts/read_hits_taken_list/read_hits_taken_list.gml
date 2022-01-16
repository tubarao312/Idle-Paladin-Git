function read_hits_taken_list() {
	
	var i;
	for (i = 0; i < ds_list_size(hitsTaken); i++) {
		hitsTaken[|i].apply_effects(hitsTaken[|i].vars, self);
	}
	
	ds_list_clear(hitsTaken);
}