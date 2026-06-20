class_name Sensor extends RefCounted

var _dict = {}
var _formulas = {}
var _value: float = 0.0

# Constructor
func _init(name: String, min: float, max: float, init: float):
	_dict.set('name', name)
	_dict.set('min', min)
	_dict.set('max', max)
	_dict.set('init', init)
	_value = init


func get_name() -> String:
	return _dict.get('name')


func set_name(name: String):
	_dict.set('name', name)


func get_min():
	return _dict.get('min')


func set_min(min):
	_dict.set('min', min)


func get_max():
	return _dict.get('max')


func set_max(max):
	return _dict.set('max', max)


func get_init():
	return _dict.get('init')


func set_init(init):
	return _dict.set('init', init)


func get_range() -> float:
	return get_max() - get_min()


func get_value() -> float:
	return _value


func set_value(value: float):
	_value = value


func get_formulas() -> Dictionary:
	return _formulas


func set_formulas(value: Dictionary):
	_formulas = value


func get_dict() -> Dictionary:
	return _dict


func reset() -> void:
	set_value(_dict.get('init'))


### Formulas ###
func set_formula(formula: Formula) -> void:
	var expressions = formula.get_expressions()
	for key: String in expressions:
		var expression = expressions.get(key)
		var formula_type = get_formula_type(key)
		if formula_type:
			formula_type.init_expression(expression)
			_formulas.set(key, expression)


func update_value() -> void:
	var new_value = 0.0
	if (get_formulas() != null):
		new_value = get_formula_value(get_formulas())
		if (new_value < get_min()):
			new_value = get_min()
		elif (new_value > get_max()):
			new_value = get_max()
			
	set_value(new_value)


func get_formula_types() -> Array[String]:
	return MITW.get_sensor_formula_types().keys()


func get_formula_type(key: String) -> SensorFormula:
	var formula_type_name = key.get_basename()
	var result = MITW.get_sensor_formula_types().get(formula_type_name)
	if !result:
		print(formula_type_name + " formula type not found.")
	return result


func get_formula_value(formulas: Dictionary) -> float:
	var result = get_value()
	SensorFormula.limit_value = false
	for key: String in formulas.keys():
		var formula_type = get_formula_type(key)
		if formula_type:
			result = formula_type.get_value(result, key, formulas)
			formula_type.increment_frame(key, formulas)
			if formula_type.is_complete():
				formula_type.set_complete(false)
				_formulas.erase(key)
		
	if (SensorFormula.limit_value && result > get_value()):
		return get_value()
		
	return result


func get_formula_text(sensor_formulas: Dictionary) -> String:
	var result = ""
	# should call to_string method in future SensorFormula Class
	if (sensor_formulas):
		for key: String in sensor_formulas:
			var formula_type = get_formula_type(key)
			if formula_type:
				result = formula_type.get_text(result, key, sensor_formulas)
				result += "\r"
			
	return result
