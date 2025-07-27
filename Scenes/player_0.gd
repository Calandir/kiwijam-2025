extends Sprite2D  # or `extends Sprite` in Godot 3.x

# Rotation speed in radians per second (e.g., PI = 180 degrees/sec)
var rotation_speed = 0.2  # Adjust this value to make it slower or faster

func _process(delta):
	rotation += rotation_speed * delta

var target_speed = 10  # final speed
var duration = 0.6  # seconds


func _on_button_pressed():
	var _bgmPlayer = get_tree().current_scene.find_child("BGMPlayer", true)
	_bgmPlayer.volume_db = -5
	var _sfxPlayer = get_tree().current_scene.find_child("SFXPlayer", true)
	_sfxPlayer.play_spell_sfx()

	increase_rotation_speed_over_time(target_speed, duration)
	var tween = create_tween()
	# Animate position to the left
	tween.tween_property(self, "position", self.position + Vector2(-192, -68), 0.5) \
	.set_trans(Tween.TRANS_SINE) \
	.set_ease(Tween.EASE_OUT)

	# Animate scale down slightly
	tween.tween_property(self, "scale", self.scale * 0.7, 0.2) \
	.set_trans(Tween.TRANS_SINE) \
	.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate", Color(0.5, 0.8, 1, 1), 0.1)
	tween.tween_property(self, "modulate", Color(0.1, 0.1, 0.1, 0.1), 0.2)

func increase_rotation_speed_over_time(target: float, time: float) -> void:
	var start_speed = rotation_speed
	var elapsed = 0.0
	var end_speed = 0.0

	while elapsed < time:
		await get_tree().process_frame  # wait one frame
		elapsed += get_process_delta_time()
		var t = elapsed / time
		rotation_speed = lerp(start_speed, target, t)
	elapsed = 0.0
	while elapsed < time:
		await get_tree().process_frame  # wait one frame
		elapsed += get_process_delta_time()
		var t = elapsed / time
		rotation_speed = lerp(target, end_speed, t)
	get_tree().change_scene_to_file("res://Scenes/chris_exploration.tscn")
