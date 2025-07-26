extends Sprite2D  # or `extends Sprite` in Godot 3.x

# Rotation speed in radians per second (e.g., PI = 180 degrees/sec)
var rotation_speed = 0.2  # Adjust this value to make it slower or faster

func _process(delta):
	rotation += rotation_speed * delta

var target_speed = 10  # final speed
var duration = 2.0  # seconds


func _on_button_pressed():
	increase_rotation_speed_over_time(target_speed, duration)

func increase_rotation_speed_over_time(target: float, time: float) -> void:
	var start_speed = rotation_speed
	var elapsed = 0.0

	while elapsed < time:
		await get_tree().process_frame  # wait one frame
		elapsed += get_process_delta_time()
		var t = elapsed / time
		rotation_speed = lerp(start_speed, target, t)
