///@arg initial amount
///@arg maximum
///@arg jump distance
function approach(initialAmount,desiredAmount,approachDistance){
		if initialAmount < desiredAmount {
			initialAmount += approachDistance
			
			if initialAmount > desiredAmount then initialAmount = desiredAmount
		} else {
			initialAmount += approachDistance
			
			if initialAmount < desiredAmount then initialAmount = desiredAmount
		}
		
		
		return initialAmount
}