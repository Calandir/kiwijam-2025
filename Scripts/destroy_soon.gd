extends Node

const TIME_TO_DESPAWN = 1
var time_since_spawn: float = 0

func _process(delta):
	time_since_spawn += delta
	
	if time_since_spawn > TIME_TO_DESPAWN:
		queue_free()
