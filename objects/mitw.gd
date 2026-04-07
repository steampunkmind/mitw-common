class_name MITW extends Object

static var _aim_model: ActionInfluenceModel = ActionInfluenceModel.new()
static var _gam_model: GovernorActionModel = GovernorActionModel.new()


static func aim_model() -> ActionInfluenceModel:
	return _aim_model


static func gam_model() -> GovernorActionModel:
	return _gam_model 


static func set_models(aim_model_dict: Dictionary, gam_model_dict: Dictionary) -> void:
	_aim_model.clear_model()
	_gam_model.clear_model()
	_aim_model.set_model(aim_model_dict)
	_gam_model.set_model(gam_model_dict, _aim_model)
