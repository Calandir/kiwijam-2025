class_name IndicatorPool
extends Node2D

@export var _indicator_scene: PackedScene

var _inactive_indicators: Array[Indicator] = []

func get_indicator() -> Indicator:
	if _inactive_indicators.is_empty():
		var new_indicator = _indicator_scene.instantiate()
		add_child(new_indicator)
		
		_inactive_indicators.append(new_indicator)
	
	var to_return: Indicator = _inactive_indicators.pop_front()
	to_return.visible = true
	return to_return

func return_indicator(indicator: Indicator) -> void:
	indicator.clear_bubble()
	indicator.visible = false
	_inactive_indicators.append(indicator)
