extends Node2D

@export var radius: float = 200.0
@export var min_delay: float = 1.0
@export var max_delay: float = 3.0

# List of dictionaries: each with 'scene' (PackedScene) and 'weight' (float)
var prefab_weights := [
	{"scene": preload("res://Scenes/bubble_blue.tscn"), "weight": 1.0},
	{"scene": preload("res://Scenes/bubble_red.tscn"), "weight": 2.0},
]

func _ready():
	spawn_loop()

func spawn_loop() -> void:
	spawn_prefab()
	var wait_time = randf_range(min_delay, max_delay)
	await get_tree().create_timer(wait_time).timeout
	spawn_loop()

func spawn_prefab():
	var prefab = pick_weighted_prefab()
	if prefab == null:
		push_warning("No prefab assigned!")
		return

	var angle = randf_range(0, TAU)  # TAU is 2π
	var spawn_pos = Vector2(cos(angle), sin(angle)) * radius
	var instance = prefab.instantiate()
	instance.global_position = global_position + spawn_pos
	get_tree().current_scene.add_child(instance)

func pick_weighted_prefab() -> PackedScene:
	var total_weight = 0.0
	for entry in prefab_weights:
		total_weight += entry.weight

	var r = randf() * total_weight
	var cumulative = 0.0
	for entry in prefab_weights:
		cumulative += entry.weight
		if r <= cumulative:
			return entry.scene
	return null
