class_name SensorFormulaSet extends SensorFormula

const TYPE = "Set"

func get_value(_value: float, key: String, formulas: Dictionary) -> float:
	return formulas.get(key)


func increment_frame(_key: String, _formulas: Dictionary) -> void:
	set_complete(true)
