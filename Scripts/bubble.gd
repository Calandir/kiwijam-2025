class_name Bubble
extends RigidBody2D

@export var type: BubbleType = BubbleType.Red
@export var our_gravity_scale: float = 0.1;
@export var _connectionHitbox: Area2D;

enum BubbleType { Red = 1, Blue = 2 }
enum BubbleState { Falling, Stuck }

var _currentState: BubbleState
var _overflowBorder: Area2D

func _ready():
	body_entered.connect(on_collision)
	_overflowBorder = get_tree().current_scene.find_child("OverflowBorder", true)
	
	set_state(BubbleState.Falling, null)

func _process(delta):
	# Center is 0, 0
	var vector_to_center = -1 * global_position
	
	if _currentState == BubbleState.Falling:
		add_constant_force(vector_to_center * our_gravity_scale)

func set_state(state: BubbleState, new_parent: Node2D):
	var previous_state: BubbleState = _currentState
	_currentState = state
	
	var test = get_tree().current_scene
	
	match state:
		BubbleState.Stuck:
			reparent(new_parent)
			freeze = true
			
			var is_game_over: bool = not _overflowBorder.overlaps_body(self)
			if is_game_over:
				get_tree().current_scene.find_child("GameState", true).set_game_over()
		BubbleState.Falling:
			if previous_state == BubbleState.Stuck:
				reparent(new_parent)
				freeze = false

func on_collision(body: Node):
	if _currentState == BubbleState.Stuck:
		return
	
	var has_hit_center = body is StaticBody2D
	var has_hit_stuck_bubble = body is Bubble and body._currentState == BubbleState.Stuck
	
	if has_hit_center or has_hit_stuck_bubble:
		# call_deferred() required to freeze physics at end of frame
		(func(): self.set_state(BubbleState.Stuck, body)).call_deferred()
		
		var matching_neighbors = _get_bubble_matching_neighbors()
		
		var all_connected: Array[Bubble] = matching_neighbors.duplicate()
		var all_matches: Array[Bubble] = matching_neighbors.duplicate()
		all_matches.append(self)
		
		for x in matching_neighbors:
			x._add_deeper_connections(all_connected, func(bubble): return true)
			x._add_deeper_connections(all_matches, func(bubble): return bubble.type == self.type)
		
		if len(all_matches) < 3:
			return
		
		var orphaned = all_connected.filter(func(x): return not all_matches.has(x))
		for orphan: Bubble in orphaned:
			(func(): orphan.set_state(BubbleState.Falling, get_tree().current_scene)).call_deferred()
			
		for x in all_matches:
			x.queue_free()

func _get_bubble_matching_neighbors() -> Array[Bubble]:
	var neighbors = _connectionHitbox.get_overlapping_bodies()
	
	var results: Array[Bubble] = []
	
	for neighbor in neighbors:
		if neighbor == self:
			continue
		
		var as_bubble = neighbor as Bubble
		if as_bubble == null or as_bubble.type != self.type:
			continue
		
		results.append(neighbor)
	
	return results

func _add_deeper_connections(already_matched: Array[Bubble], is_valid_check: Callable):
	if not already_matched.has(self):
		already_matched.append(self)
	
	var bubble_children = get_children().filter(func(x): return x as Bubble != null)
	
	for bubble in bubble_children:
		if not is_valid_check.call(bubble):
			continue
		
		if not already_matched.has(bubble):
			already_matched.append(bubble)
			bubble._add_deeper_connections(already_matched, is_valid_check)
	
	var parent = get_parent()
	var parent_as_bubble = parent as Bubble
	if parent_as_bubble != null and (not already_matched.has(parent)) and is_valid_check.call(parent_as_bubble):
		already_matched.append(parent)
		parent._add_deeper_connections(already_matched, is_valid_check)
