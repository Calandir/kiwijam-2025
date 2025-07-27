extends Node

@export var is_enabled: bool = true

const TIME_TO_DESPAWN = 1
var time_since_spawn: float = 0

func _process(delta):
	if not is_enabled:
		return
	
	time_since_spawn += delta
	
	if time_since_spawn > TIME_TO_DESPAWN:
		queue_free()
