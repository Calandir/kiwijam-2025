extends Sprite2D  # or `extends Sprite` in Godot 3.x

# Rotation speed in radians per second (e.g., PI = 180 degrees/sec)
var rotation_speed = 0.03  # Adjust this value to make it slower or faster

func _process(delta):
	rotation += rotation_speed * delta
