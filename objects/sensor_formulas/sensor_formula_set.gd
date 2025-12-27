class_name SensorFormulaSet extends SensorFormula

const TYPE = "Set"

func get_value(value: float, key: String, formulas: Dictionary) -> float:
	return formulas.get(key)


func increment_frame(key: String, formulas: Dictionary) -> void:
	set_complete(true)
