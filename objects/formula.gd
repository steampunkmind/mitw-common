class_name Formula extends RefCounted

var _dict

# Constructor
func _init(expressions: Dictionary):
	_dict = expressions
	
	
func get_expressions() -> Dictionary:
	return _dict
	
	
func get_dict() -> Dictionary:
	return _dict


func to_text() -> String:
	var result: String = ""
	var i: int = 0
	for key: String in get_expressions().keys():
		if i > 0:
			result += ", "
		result += key + ": "
		result += _expression_to_text(get_expressions().get(key))
		i += 1
	return result


func _expression_to_text(expression) -> String:
	var result: String = ""
	if expression is String:
		result = expression
	elif expression is int or expression is float:
		result = str(expression)
	elif expression is Array:
		result = _array_to_text(expression)
	elif expression is Dictionary:
		result = _dict_to_text(expression)
	else:
		print("Could not convert: \"" + str(expression) + "\" to text.")
	return result


func _array_to_text(array: Array) -> String:
	var result: String = "["
	for item in array:
		if result.length() > 1:
			result += ", "
		result += _expression_to_text(item)
	result += "]"
	return result


func _dict_to_text(dict: Dictionary) -> String:
	var result: String = "{"
	for key: String in dict.keys():
		if result.length() > 1:
			result += ", "
		result += key + ": "
		result += _expression_to_text(dict.get(key))
	result += "}"
	return result
