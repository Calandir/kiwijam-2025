extends RigidBody2D

func _enter_tree():
	body_entered.connect(on_collision)

func on_collision(body: Node):
	pass
