class_name SensorFormulaLinear extends SensorFormula

const TYPE = "Linear"

func init_expression(expression) -> void:
	if expression is Dictionary:
		expression.set("timer", expression.get("duration"))


func get_value(value: float, key: String, formulas: Dictionary) -> float:
	var formula = formulas.get(key)
	if formula is Dictionary:
		return value + formula.get("value")
	
	return super.get_value(value, key, formulas)


func increment_frame(key: String, formulas: Dictionary) -> void:
	var formula = formulas.get(key)
	if formula is Dictionary:
		var timer = formula.get("timer")
		if timer > 0:
			timer = timer - 1
			formula.set("timer", timer)
		else:
			set_complete(true)

	
	
