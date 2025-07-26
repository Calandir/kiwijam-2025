extends Node

@export var _spawn_template: PackedScene

@export var _spawn_container: Node2D

func _process(delta):
	if Input.is_action_just_pressed("debug_spawn_bubble"):
		var spawned: Node2D = _spawn_template.instantiate()
		
		# This location is wrong because need to translate mouse position to screen position, whatever this is a debug tool
		spawned.position = get_viewport().get_mouse_position()
		
		_spawn_container.add_child(spawned)
