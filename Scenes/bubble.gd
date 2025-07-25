extends RigidBody2D

@export var our_gravity_scale: float = 0.1;

enum BubbleState { Falling, Stuck }

var _currentState: BubbleState

func _enter_tree():
	body_entered.connect(on_collision)
	
	set_state(BubbleState.Falling)

func _process(delta):
	# Center is 0, 0
	var vector_to_center = -1 * global_position
	
	if _currentState == BubbleState.Falling:
		add_constant_force(vector_to_center * our_gravity_scale)

func set_state(state: BubbleState):
	_currentState = state
	
	match state:
		BubbleState.Stuck:
			set_constant_force(Vector2.ZERO)
			set_constant_torque(0)

func on_collision(body: Node):
	set_state(BubbleState.Stuck)
