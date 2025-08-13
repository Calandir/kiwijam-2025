class_name Indicator
extends Node2D

var _bubble: Node2D

func set_bubble(bubble: Node2D) -> void:
	_bubble = bubble
	self.global_position = _bubble.global_position

func clear_bubble() -> void:
	_bubble = null

func _process(delta: float) -> void:
	if not _bubble:
		return
	
	self.global_position = _bubble.global_position
