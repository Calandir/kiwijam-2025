class_name Bubble
extends RigidBody2D

@export var type: BubbleType = BubbleType.Red
@export var our_gravity_scale: float = 0.1;
@export var _connectionHitbox: Area2D;

enum BubbleType { Red, Blue }
enum BubbleState { Falling, Stuck }

var _currentState: BubbleState

func _ready():
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
			reparent(get_tree().current_scene.find_child("Center"))
			freeze = true

func on_collision(body: Node):
	var has_hit_center = body is StaticBody2D
	var has_hit_stuck_bubble = body is Bubble and body._currentState == BubbleState.Stuck
	
	if has_hit_center or has_hit_stuck_bubble:
		# call_deferred() required to freeze physics at end of frame
		(func(): self.set_state(BubbleState.Stuck)).call_deferred()
		
		var bubble_matches = {}
		search_all_from_neighbors(bubble_matches, func(bubble):return bubble.type == self.type)
		
		if len(bubble_matches) < 3:
			return
		
		for bubble_match in bubble_matches:
			bubble_match.queue_free()
		
		self.queue_free()

# Using dict as set because no Set type
func search_all_from_neighbors(found_nodes: Dictionary, is_valid_func: Callable):
	found_nodes[self] = ""  # dummy value
	
	var neighbors = _get_bubble_neighbors()
	
	for neighbor in neighbors:
		if not found_nodes.has(neighbor) and is_valid_func.call(neighbor):
			found_nodes[neighbor] = ""  # dummy value
			neighbor.search_all_from_neighbors(found_nodes, is_valid_func)

func _get_bubble_neighbors():
	var neighbors = _connectionHitbox.get_overlapping_bodies()
	
	return neighbors.filter(func(x): return (x != self) and (x as Bubble) != null)
