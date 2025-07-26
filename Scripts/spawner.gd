extends Node2D

@export var prefab: PackedScene
@export var radius: float = 200.0
@export var min_delay: float = 1.0
@export var max_delay: float = 3.0

func _ready():
	spawn_loop()

func spawn_loop() -> void:
	# Infinite coroutine-style spawn loop
	spawn_prefab()
	var wait_time = randf_range(min_delay, max_delay)
	await get_tree().create_timer(wait_time).timeout
	spawn_loop()

func spawn_prefab():
	if prefab == null:
		push_warning("No prefab assigned!")
		return

	# Choose a random angle around a circle
	var angle = randf_range(0, TAU)  # TAU is 2π
	var spawn_pos = Vector2(cos(angle), sin(angle)) * radius
	var instance = prefab.instantiate()
	instance.global_position = global_position + spawn_pos
	get_tree().current_scene.add_child(instance)
