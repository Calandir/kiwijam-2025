extends Node2D

var dragging := false
@export var max_rotation_speed := 3  # radians per second
@export var smoothing := 10.0  # higher means faster smoothing
@export var game_state: GameState

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
	elif event is InputEventScreenTouch:
		dragging = event.pressed

func _process(delta):
	if game_state.is_game_over:
		dragging = false
		return
	
	if dragging:
		var pointer_pos = get_global_mouse_position()
		var target_angle = (pointer_pos - global_position).angle() + deg_to_rad(90)

		# Smoothly interpolate rotation towards target
		rotation = lerp_angle(rotation, target_angle, smoothing * delta)

		# Optionally clamp max rotation speed (soft cap)
		var angle_diff = wrapf(target_angle - rotation, -PI, PI)
		var max_step = max_rotation_speed * delta
		if abs(angle_diff) > max_step:
			rotation += sign(angle_diff) * max_step
