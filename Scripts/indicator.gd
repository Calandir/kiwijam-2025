class_name Indicator
extends Node2D

@export var _sprite2D: Sprite2D

static var min_corner: Vector2 = Vector2(-1200, -1200)
static var max_corner: Vector2 = Vector2(1200, 1200)

var _bubble: Node2D

func set_bubble(bubble: Node2D) -> void:
	_bubble = bubble
	_sprite2D.texture = bubble.find_child("Sprite2D").texture
	
	self.global_position = _bubble.global_position

func clear_bubble() -> void:
	_bubble = null

func _process(delta: float) -> void:
	if not _bubble:
		return
	
	var clamped_position = _bubble.global_position.clamp(min_corner, max_corner)
	self.global_position = clamped_position
