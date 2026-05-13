class_name PerceptionFormula extends RefCounted

var _is_complete: bool = false

func get_value(value: float, _key: String, _formulas: Dictionary) -> float:
	return value


func get_text(_key: String, _formulas: Dictionary) -> String:
	return "—"


func init_expression(_expression) -> void:
	pass # Override to init expression before adding to sensor.


func increment_frame(_key: String, _formulas: Dictionary) -> void:
	pass # Override to track frames and set is_complete if appropriate.


func set_complete(_complete: bool) -> void:
	_is_complete = _complete


func is_complete() -> bool:
	return _is_complete
