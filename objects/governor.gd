class_name Governor extends RefCounted

var _dict: Dictionary
var _sensor: Sensor
var _perception_types = {} 
var _perception_formulas = {}
var _action_evaluators: Dictionary # Holds evaluator for every behavioral action
var _error_value

# Constructor
func _init(dict: Dictionary, sensor: Sensor, aim_model: ActionInfluenceModel):
	_dict = dict
	_sensor = sensor
	var evaluator = _dict.get("evaluator")
	for action: Action in aim_model.get_behavioral_actions():
		_action_evaluators.set(action, ActionEvaluator.new(evaluator))
			
	_perception_types.set(PerceptionFormulaOffset.TYPE, PerceptionFormulaOffset.new())
	_perception_types.set(PerceptionFormulaIntermittent.TYPE, PerceptionFormulaIntermittent.new())
	
	var perceptions = _dict.get("perceptions")
	if perceptions:
		for perception in perceptions:
			var formula = Formula.new(perception)
			set_percept_formula(formula)


func get_name():
	return _dict.get('name')


# The sensor value at which this governor starts producing an error. 
# Errors always start at zero and are positive values.
func error_threshold():
	return _dict.get('error_threshold')


# The sensor value at which this governor produces its maximum error value. 
# Errors always start at zero and are positive values.
func error_peak():
	return _dict.get('error_peak')


# The maximum error value this governor will produce.
# The sensor value will be at error_peak when error_max is produced.
# Beyond this point, changes in the sensor value will not effect the error value. 
func error_max():
	return _dict.get('error_max')


func error_min():
	return 0


func get_sensor():
	return _sensor


func get_sensor_value() -> float:
	return _sensor.get_value()


func get_sensor_name() -> String:
	if _sensor: 
		return _sensor.get_name()
	return "NOT FOUND"


func is_max_type() -> bool:
	return error_threshold() < error_peak()


func is_min_type() -> bool:
	return error_peak() < error_threshold()


func get_dict() -> Dictionary:
	var result = _dict.duplicate()
	result.set('sensor', _sensor.get_name())
	return result


func set_error_value(error_value: float):
	_error_value = error_value


func get_error_value() -> float:
	return _error_value


func get_votes(action: Action) -> float:
	var evaluator = _action_evaluators.get(action)
	if evaluator:
		var evaluation_value = evaluator.get_evaluation_value()
		if evaluation_value: 
			return evaluation_value * _error_value
	return 0.0


func update_values() -> void:
	update_percept_value()
	update_error_value()
	update_action_evaluations()

### Perception ###
func update_percept_value() -> void:
	var new_value = _get_percept_formula_value(_perception_formulas)
	set_percept_value(new_value)


func get_percept_value() -> float:
	return _dict.get('percept_value')


func set_percept_value(value: float):
	_dict.set('percept_value', value)


func get_perception_text() -> String:
	var result = ""
	for key: String in _perception_formulas.keys():
		var formula_type = get_formula_type(key)
		if formula_type:
			if result.length() > 0:
				result += ", "
			result += formula_type.get_text(key, _perception_formulas)
			
	return result


func set_percept_formula(formula: Formula) -> void:
	var expressions = formula.get_expressions()
	for key: String in expressions:
		var expression = expressions.get(key)
		var formula_type = get_formula_type(key)
		if formula_type:
			formula_type.init_expression(expression)
			_perception_formulas.set(key, expression)


func _get_percept_formula_value(formulas: Dictionary) -> float:
	var result = _sensor.get_value()
	for key: String in formulas.keys():
		var formula_type = get_formula_type(key)
		if formula_type:
			result = formula_type.get_value(result, key, formulas)
			formula_type.increment_frame(key, formulas)
			if formula_type.is_complete():
				formula_type.set_complete(false)
				_perception_formulas.erase(key)
				
	return result

func get_formula_type(key: String) -> PerceptionFormula:
	var formula_type_name = key.get_basename()
	var result = _perception_types.get(formula_type_name)
	if !result:
		print(formula_type_name + " formula type not found.")
	return result


### Error Value ###
func update_error_value() -> void:
	var value = get_percept_value();
	if (value > get_sensor().get_max()):
		value = get_sensor().get_max()
	elif (value < get_sensor().get_min()):
		value = get_sensor().get_min()
	
	_error_value = 0
	if (error_threshold() >= error_peak()):
		if (value < error_peak()): 
			_error_value = error_max()
		elif (value < error_threshold()):
			_error_value = calc_error_value(value)
	else:
		if (error_peak() < value): 
			_error_value = error_max()
		elif (error_threshold() < value):
			_error_value = calc_error_value(value)


func calc_error_value(value: float) -> float:
	return error_max() * (value - error_threshold())/(error_peak() - error_threshold())


### Action Opinions ###
func set_action(action: Action) -> void:
	_action_evaluators.get(action).start_evaluating()


func is_evaluating_action(action: Action) -> bool:
	return _action_evaluators.get(action).is_evaluating()


### Action Evaluating ###
func update_action_evaluations() -> void:
	var percept_value = get_percept_value()
	for action_evaluator: ActionEvaluator in _action_evaluators.values():
		action_evaluator.update_evaluation(percept_value, is_max_type())


func get_action_evaluation_value(action: Action) -> float:
	return _action_evaluators.get(action).get_evaluation_value()


func get_action_evaluation_text(action: Action) -> String:
	return _action_evaluators.get(action).get_evaluation_text()


func get_action_evaluation_progress(action: Action) -> float:
	return _action_evaluators.get(action).get_evaluation_progress()


func get_action_evaluation_influence(action: Action) -> float:
	return _action_evaluators.get(action).get_evaluation_influence()


### Comparator ###
func error_threshold_percent() -> float:
	return _calc_percept_percent(error_threshold())


func error_peak_percent() -> float:
	return _calc_percept_percent(error_peak())


func _calc_percept_percent(value: float) -> float:
	return (percept_range() - (value - get_sensor().get_min()))/percept_range()


func percept_range() -> float:
	return get_sensor().get_max()-get_sensor().get_min()
