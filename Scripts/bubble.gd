class_name Bubble
extends RigidBody2D

@export var type: BubbleType = BubbleType.Red
@export var our_gravity_scale: float = 0.1;
@export var _connectionHitbox: Area2D;
@export var _spawnOnCombo: Array[PackedScene]
@export var _showWhenFalling: Array[Node2D]
@export var max_velocity: float = 750.0 

enum BubbleType
{
	Red = 1,
	Blue = 2,
	Green = 3,
	Yellow = 4,
	Brown = 5,
	Purple = 6,
}
enum BubbleState { Falling, Stuck }

var _currentState: BubbleState
var _overflowBorder: Area2D
var _sfxPlayer: Node

var _spawnFrame: int
var _lastStateChangedFrame: int = -1

static var s_graph: BubbleGraph = BubbleGraph.new()
static var s_center: Node2D

func _ready():
	body_entered.connect(on_collision)
	_sfxPlayer = get_tree().current_scene.find_child("SFXPlayer", true)
	
	if not s_center:
		s_center = get_tree().current_scene.find_child("Center", true)
	
	_spawnFrame = Engine.get_frames_drawn()
	set_state(BubbleState.Falling, null)

func _process(delta):
	# Hack to clean up distant satellites
	if Engine.get_frames_drawn() > _spawnFrame + 300 and position.length_squared() > 1200 * 1200:
		queue_free()
	
	# Center is 0, 0
	var vector_to_center = -1 * global_position
	
	if _currentState == BubbleState.Falling:
		add_constant_force(vector_to_center * our_gravity_scale)
		
		# Limit velocity
		if linear_velocity.length() > max_velocity:
			linear_velocity = linear_velocity.normalized() * max_velocity

func set_state(state: BubbleState, new_parent: Node2D):
	var previous_state: BubbleState = _currentState
	_currentState = state
	
	match state:
		BubbleState.Stuck:
			if is_instance_valid(self):
				for x in _showWhenFalling:
					x.visible = false
				
			reparent(new_parent)
			freeze = true
			
			# HACK: Don't actually use _overflow_border, sometimes it returned False unexpectedly
			var is_game_over: bool = self.global_position.distance_to(Vector2.ZERO) > 875
			if is_game_over and is_inside_tree():
				var game_state = get_tree().current_scene.find_child("GameState", true)
				if game_state != null:
					game_state.set_game_over()
					
		BubbleState.Falling:
			if previous_state == BubbleState.Stuck:
				reparent(new_parent)
				freeze = false

func on_collision(body: Node):
	if _currentState != BubbleState.Falling:
		return
	
	var has_hit_stuck_bubble = body is Bubble and body._currentState == BubbleState.Stuck
	var has_hit_center = body.name == "CenterArea2D"

	if not has_hit_center and not has_hit_stuck_bubble:
		return
	
	# It's possible to collide with two objects in the same frame
	# If that happens, only run match logic once
	var has_already_processed = _lastStateChangedFrame == Engine.get_frames_drawn()
	if has_already_processed:
		return
	_lastStateChangedFrame = Engine.get_frames_drawn()
	
	# call_deferred() required to freeze physics at end of frame
	(func(): self.set_state(BubbleState.Stuck, s_center)).call_deferred()
	
	s_graph.add(self)
	
	var all_matches = s_graph.get_matches_of(self, func(bubble): return bubble.type == self.type)
	if len(all_matches) < 3:
		return
	
	s_graph.remove(all_matches)
	
	for x in all_matches:
		x._bubble._play_effect()
		x._bubble.queue_free()

# OLD STUFF BELOW

func on_collision_old(body: Node):
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
			if has_hit_center and len(all_matches) == 1:
				_sfxPlayer.play_miss_sfx()
			else:
				_sfxPlayer.play_connect_sfx()
			return
		
		_sfxPlayer.play_spell_sfx()

		var orphaned = all_connected.filter(func(x): return not all_matches.has(x))
		for orphan: Bubble in orphaned:
			(func(): orphan.set_state(BubbleState.Falling, get_tree().current_scene)).call_deferred()
			
		for x in all_matches:
			x._play_effect()
			x.queue_free()
		
		var game_state = get_tree().current_scene.find_child("GameState", true)
		if game_state != null:
			game_state.add_score(len(all_matches) * len(all_matches))

func _play_effect():
	if not is_inside_tree():
		return
	
	for effect in _spawnOnCombo:
		var new = effect.instantiate()
		new.position = self.global_position
		get_tree().current_scene.add_child(new)
	
	queue_free()

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
