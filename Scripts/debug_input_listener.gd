extends Node2D

@export var _spawn_template_red: PackedScene
@export var _spawn_template_blue: PackedScene

@export var _spawn_container: Node2D

func _process(delta):
	if Input.is_action_just_pressed("debug_spawn_bubble_red"):
		_instantiate(_spawn_template_red)
		
	if Input.is_action_just_pressed("debug_spawn_bubble_blue"):
		_instantiate(_spawn_template_blue)

func _instantiate(template: PackedScene):
	var spawned: Node2D = template.instantiate()
		
	spawned.position = get_global_mouse_position()
	
	_spawn_container.add_child(spawned)
