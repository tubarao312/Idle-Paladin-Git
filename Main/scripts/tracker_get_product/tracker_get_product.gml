// Returns an array with the product of each of the tracker's arrays
function tracker_get_product(tracker) {
	var productArray = array_create(tracker.arraySize, 1);
	
	var i, j;
	
	for (i = 0; i < tracker.arrayAmount; i++) { // Run through the list
		var specificArray = tracker_get_array(tracker, i); // Get the array for index 'i'
		
		for (j = 0; j < tracker.arraySize; j++) { // Run through each array
			productArray[j] *= specificArray[j]; // Add the array of index 'i' to the final result
		}
	}
	
	return productArray;
}