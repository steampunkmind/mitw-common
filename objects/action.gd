class_name Action extends RefCounted

var _dict = {}
var _influences: Array[Influence]
var _name_width: float

# Constructor
func _init(name: String, behavioral: bool, influences: Array[Influence] = []):
	_dict.set('name', name)
	_dict.set('behavioral', behavioral)
	_influences = influences
	
	
func get_name():
	return _dict.get('name')
	
	
func get_behavioral():
	return _dict.get('behavioral')
	
	
func get_influences() -> Array[Influence]:
	return _influences
	
	
func set_influences(value: Array[Influence]) -> void:
	_influences = value
	
	
func get_dict() -> Dictionary:
	var result = _dict.duplicate(true)
	var influences = {}
	for influence: Influence in _influences:
		influences.set(influence.get_sensor_name(), influence.get_dict())
	result.set('influences', influences)
	return result
	
	
func get_name_width() -> float:
	return _name_width


func set_name_width(value: float) -> void:
	_name_width = value
