extends Node2D

@export var _spawn_template: PackedScene

@export var _spawn_container: Node2D

func _process(delta):
	if Input.is_action_just_pressed("debug_spawn_bubble"):
		var spawned: Node2D = _spawn_template.instantiate()
		
		spawned.position = get_global_mouse_position()
		
		_spawn_container.add_child(spawned)
