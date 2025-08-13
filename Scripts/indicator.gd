class_name Indicator
extends Node2D

@export var _sprite2D: Sprite2D
@export var _arrow: Node2D

static var min_corner: Vector2 = Vector2(-1100, -1100)
static var max_corner: Vector2 = Vector2(1100, 1100)

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
	
	var position_diff: Vector2 = _bubble.global_position - clamped_position
	var angle_degrees = rad_to_deg(position_diff.normalized().angle())
	
	# Ensure the arrow always points to an edge
	angle_degrees = _get_closest_degrees(angle_degrees)
	
	_arrow.rotation_degrees = angle_degrees

func _get_closest_degrees(input_degrees: float) -> float:
	var to_compare: Array[float] = [-180, -90, 0, 90, 180]
	var current_best = -180
	
	for num in to_compare:
		if abs(num - input_degrees) < abs(current_best - input_degrees):
			current_best = num
	
	return current_best
