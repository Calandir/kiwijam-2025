class_name Bubble
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
			freeze = true

func on_collision(body: Node):
	var has_hit_center = body is StaticBody2D
	var has_hit_stuck_bubble = body is Bubble and body._currentState == BubbleState.Stuck
	
	if has_hit_center or has_hit_stuck_bubble:
		# call_deferred() required to freeze physics at end of frame
		(func(): self.set_state(BubbleState.Stuck)).call_deferred()
