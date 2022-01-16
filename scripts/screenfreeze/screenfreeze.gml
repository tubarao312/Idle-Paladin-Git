///@darg duration (ms)

function screenfreeze(duration) {
	var _t = current_time + duration;

	while (current_time < _t) {};
}
