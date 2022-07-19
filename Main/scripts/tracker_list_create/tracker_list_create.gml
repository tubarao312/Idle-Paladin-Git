// Creates a struct to keep track of the sum/multiplication of all of the
// player's or even enemy's stats.
function tracker_list_create(arrayAmount, arraySize) {
	var tracker = {};
	tracker.list = ds_list_create();
	tracker.arraySize = arraySize;
	tracker.arrayAmount = arrayAmount;
	
	var i; for (i = 0; i < arrayAmount; i++) { // Adding all the arrays to the list
		ds_list_add(tracker.list, array_create(arraySize, 0));
	}
	
	return tracker;
}