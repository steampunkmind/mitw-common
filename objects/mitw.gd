class_name MITW extends Object

static var _aim_model: ActionInfluenceModel = ActionInfluenceModel.new()
static var _gam_model: GovernorActionModel = GovernorActionModel.new()

static var _frame_count: int = 0
static var _waiting_value: int = 0
static var _wondering_value: int = 0
static var _total_error_value: float = 0.0

static func aim_model() -> ActionInfluenceModel:
	return _aim_model


static func gam_model() -> GovernorActionModel:
	return _gam_model 


static func init(aim_model_dict: Dictionary, gam_model_dict: Dictionary) -> void:
	_frame_count = 0
	_waiting_value = 0
	_wondering_value = 0
	_total_error_value = 0.0
	
	_aim_model.clear_model()
	_gam_model.clear_model()
	_aim_model.set_model(aim_model_dict)
	_gam_model.set_model(gam_model_dict, _aim_model)


static func get_frame_count() -> int:
	return _frame_count


static func get_waiting_value() -> int:
	return _waiting_value


static func get_waiting_countdown() -> int:
	return _gam_model.get_waiting() - _waiting_value


static func get_wondering_value() -> int:
	return _wondering_value


static func get_wondering_countdown() -> int:
	return _gam_model.get_wondering() - _wondering_value


static func get_total_error_value() -> int:
	return _total_error_value


static func init_action() -> void:
	set_action(aim_model().get_actions()[0])


static func set_action(action: Action) -> void:
	_aim_model.set_action(action)
	if (action.get_behavioral()): # only behavioral actions are evaluated by governors
		for governor: Governor in _gam_model.get_governors():
			governor.set_action(action)


static func go_to_next_frame() -> void:
	for sensor in _aim_model.get_sensors():
		sensor.update_value()
	
	_total_error_value = 0.0
	for governor: Governor in _gam_model.get_governors():
		governor.update_values()
		_total_error_value += governor.get_error_value()
		
	if _waiting_value > 0:
		_waiting_value += 1
	if _wondering_value > 0:
		_wondering_value += 1
		
	if _total_error_value > 0:
		if _waiting_value == 0:
			_waiting_value = 1
			_wondering_value = 0
			set_action(_gam_model.get_highest_votes_action())
	else:
		if _waiting_value == 0 and _wondering_value == 0:
			_wondering_value = 1
			
	if _waiting_value > _gam_model.get_waiting():
		_waiting_value = 0
		
	if _wondering_value > _gam_model.get_wondering():
		_waiting_value = 1
		_wondering_value = 0
		set_action(_gam_model.get_random_action())
		
	_frame_count += 1


### Functions for SensorFormula classes ###
static func select_action(action_name: String) -> void:
	for action: Action in _aim_model.get_actions():
		if (action.get_name() == action_name):
			set_action(action)
			break


static func shuffle_action(action_names) -> void:
	var actions_to_shuffle = []
	for action: Action in _aim_model.get_actions():
		if action_names.has(action.get_name()):
			actions_to_shuffle.append(action)
	
	var influences_array = []
	for action: Action in actions_to_shuffle:
		var influences = action.get_influences()
		influences_array.append(influences)
		
	influences_array.shuffle()
	
	var influences_index = 0
	for action: Action in actions_to_shuffle:
		var influences = influences_array[influences_index]
		action.set_influences(influences)
		influences_index = influences_index + 1
