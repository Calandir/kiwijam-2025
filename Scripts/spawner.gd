extends Node2D

@export var radius: float = 200.0
@export var game_state: GameState

var _total_seconds: float = 0

var _current_difficulty: int = 0

var prefabs := [
	{"scene": preload("res://Scenes/bubble_red.tscn"), "weight": 1.0, "min_difficulty": 1},
	{"scene": preload("res://Scenes/bubble_blue.tscn"), "weight": 1.0, "min_difficulty": 1},
	{"scene": preload("res://Scenes/bubble_green.tscn"), "weight": 1.0, "min_difficulty": 1},
	{"scene": preload("res://Scenes/bubble_yellow.tscn"), "weight": 1.0, "min_difficulty": 1},
	{"scene": preload("res://Scenes/bubble_purple.tscn"), "weight": 1.0, "min_difficulty": 1},
	{"scene": preload("res://Scenes/bubble_brown.tscn"), "weight": 1.0, "min_difficulty": 1},
]

const difficulty_settings := [
	{"start_at_seconds": 0, "min_delay": 1, "max_delay": 3, "num_types": 2, "new_spawn_thread": false},
	{"start_at_seconds": 10, "min_delay": 1, "max_delay": 2, "num_types": 3, "new_spawn_thread": false},
	{"start_at_seconds": 30, "min_delay": 1.5, "max_delay": 3.5, "num_types": 4, "new_spawn_thread": true},
	{"start_at_seconds": 50, "min_delay": 1.5, "max_delay": 3.5, "num_types": 5, "new_spawn_thread": false},
	{"start_at_seconds": 70, "min_delay": 1, "max_delay": 3, "num_types": 6, "new_spawn_thread": false},
]

func _ready():
	print("Starting at difficulty 0")
	spawn_loop()
	
func _process(delta):
	_total_seconds += delta
	
	var max_difficulty = len(difficulty_settings) - 1
	if _current_difficulty < max_difficulty:
		var settings = difficulty_settings[_current_difficulty]
		
		if _total_seconds >= difficulty_settings[_current_difficulty + 1].start_at_seconds:
			print("Difficulty has reached level " + str(_current_difficulty) + " of " + str(max_difficulty))
			_current_difficulty += 1
			settings = difficulty_settings[_current_difficulty]
			
			if settings.new_spawn_thread == true:
				spawn_loop()

func spawn_loop() -> void:
	spawn_prefab()
	var settings = difficulty_settings[_current_difficulty]
	
	var wait_time = randf_range(settings.min_delay, settings.max_delay)
	await get_tree().create_timer(wait_time).timeout
	
	if not game_state.is_game_over:
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
	var settings = difficulty_settings[_current_difficulty]
	var prefab_subset = prefabs.slice(0, settings.num_types)
	
	var total_weight = 0.0
	for entry in prefab_subset:
		total_weight += entry.weight

	var r = randf() * total_weight
	var cumulative = 0.0
	for entry in prefab_subset:
		cumulative += entry.weight
		if r <= cumulative:
			return entry.scene
	return null
