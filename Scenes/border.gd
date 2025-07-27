extends Sprite2D  # or `extends Sprite` in Godot 3.x

# Rotation speed in radians per second (e.g., PI = 180 degrees/sec)
var rotation_speed_base = 0.03  # Adjust this value to make it slower or faster
var acceleration = 2.5 # Adjust the value to make it speed up more or less based on the difficulty
var spawner # Set up variable spawner

func _process(delta):
	if spawner == null: # For some reason this only works here, not before)
		spawner = get_tree().current_scene.find_child("Spawner", true) # Finds the spawner node
	
	if spawner == null:
		return
	
	var Difficulty = spawner._current_difficulty # Fetches the current difficulty variable from spawner 
	var rotation_speed = rotation_speed_base * (pow(acceleration,Difficulty))
	rotation += rotation_speed * delta
