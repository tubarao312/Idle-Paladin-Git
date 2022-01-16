///@arg string
///@arg max length
function separate_phrase(str,length){
	var result = ""
	var height = 1
	
	var i,lastSpace
	lastSpace = string_length(str)
	
	while str != "" {
		for (i = 0; i < length; i++) {
			if string_char_at(str,i) = " " or string_char_at(str,i) = "." then lastSpace = i
		}
		
		result = result + string_copy(str,0,lastSpace) + "\n"
		str = string_delete(str,1,lastSpace)
		height ++
	}
	
	if string_copy(result,string_length(result)-2,2) = "\n" then result = string_delete(result,string_length(result)-2,2)
	
	return [result,height]
}