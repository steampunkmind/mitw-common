class_name SensorFormulaMultiply extends SensorFormula

const TYPE = "Multiply"

func get_value(_value: float, key: String, formulas: Dictionary) -> float:
	return _value * formulas.get(key)


func increment_frame(_key: String, _formulas: Dictionary) -> void:
	set_complete(true)
