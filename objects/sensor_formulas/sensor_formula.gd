class_name SensorFormula extends RefCounted

static var action_agent
static var limit_value

var _is_complete: bool = false

func get_value(value: float, key: String, formulas: Dictionary) -> float:
	return value + formulas.get(key)


func get_text(text: String, key: String, formulas: Dictionary) -> String:
	return text + key + ": " + str(formulas.get(key))


func _sensor_list_text(text: String, key: String, formulas: Dictionary) -> String:
	var result = key + ": ["
	var cnt = 0
	for sensor_name: String in formulas.get(key):
		if (cnt > 0):
			result += ", "
		result += sensor_name
		cnt += 1
	result += "]"
	return text + result


func init_expression(expression) -> void:
	pass # Override to init expression before adding to sensor.


func increment_frame(key: String, formulas: Dictionary) -> void:
	pass # Override to track frames and set is_complete if appropriate.


func set_complete(is_complete: bool) -> void:
	_is_complete = is_complete


func is_complete() -> bool:
	return _is_complete
