class_name ActionInfluenceModel extends Object

var _actions: Array[Action]
var _behavioral_actions: Array[Action]
var _sensors = {}
var _sensor_dict = {}
var _edit_mode: bool = false:
	get = get_edit_mode, set = set_edit_mode


func set_model(json) -> void:
	set_action_dicts(json.get('actions') as Array)
	set_sensor_dicts(json.get('sensors') as Array)


func clear_model() -> void:
	_actions.clear()
	_behavioral_actions.clear()
	_sensors.clear()
	_sensor_dict.clear()
	_edit_mode = false


func is_model() -> bool:
	return _actions.size() > 0 || _sensors.size() > 0


## Actions ##
func get_actions() -> Array[Action]:
	return _actions


func get_behavioral_actions() -> Array[Action]:
	return _behavioral_actions


func get_action_dicts() -> Array:
	var result = []
	for action: Action in _actions:
		result.append(action.get_dict())	
	return result


func set_action_dicts(action_dicts: Array) -> void:
	fill_actions(action_dicts)


func fill_actions(action_array: Array) -> void:
	_actions.clear()
	_behavioral_actions.clear()
	for action_dict: Dictionary in action_array:
		var influences: Array[Influence]
		var influence_dict = action_dict.get("influences")
		for sensor_name: String in influence_dict:
			var expressions = influence_dict.get(sensor_name)
			var formula = Formula.new(expressions)
			var influence = Influence.new(sensor_name, formula)
			influences.append(influence)
		
		var action = Action.new(action_dict.get("name"), action_dict.get("behavioral"), influences)
		_actions.append(action)
		if action.get_behavioral():
			_behavioral_actions.append(action)


func set_action(action: Action) -> void:
	for influence: Influence in action.get_influences():
		var sensor = get_sensor(influence.get_sensor_name())
		sensor.set_formula(influence.get_formula())


## Sensors ##
func get_sensors() -> Array:
	return _sensors.values()


func set_sensors(value: Array[Sensor]):
	_sensors.clear()
	for sensor: Sensor in value:
		_sensors.set(sensor.get_name(), sensor)
	


func get_sensor(name: String) -> Sensor:
	return _sensors.get(name)


func get_sensor_dicts() -> Array:
	var sensor_dicts = []
	for sensor: Sensor in _sensors.values():
		sensor_dicts.append(sensor.get_dict())	
	return sensor_dicts


func set_sensor_dicts(sensor_dicts: Array) -> void:
	fill_sensors(sensor_dicts)


func fill_sensors(sensor_dicts: Array) -> void:
	_sensors = {}
	for sensor_dict: Dictionary in sensor_dicts:
		var sensor_name = sensor_dict.get('name')
		var sensor_min = sensor_dict.get('min')
		var sensor_max = sensor_dict.get('max')
		var sensor_init = sensor_dict.get('init')
		_sensors.set(sensor_name, Sensor.new(sensor_name, sensor_min, sensor_max, sensor_init))


func new_sensor() -> void:
	var name = "Sensor " + str(_sensors.size()+1)
	_sensors.set(name, Sensor.new(name, 0, 100, 50))


func reset_sensors():
	for sensor in get_sensors():
		sensor.reset()


## Edit Mode ##
func get_edit_mode() -> bool:
	return _edit_mode


func set_edit_mode(value: bool) -> void:
	_edit_mode = value
