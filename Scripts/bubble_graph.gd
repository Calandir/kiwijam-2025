class_name BubbleGraph

const CONNECT_DISTANCE_SQUARED = 90 * 90
const CENTER_RADIUS_SQUARED = 350 * 350

var _bubbles = {}
var _graphNodes: Array[BubbleGraphNode] = []

func add(bubble: Bubble):
	if _bubbles.has(bubble):
		return
	
	#print("Add " + str(bubble.get_instance_id()))
	_bubbles[bubble] = ""
	_rebuild()

func remove(graph_nodes: Array[BubbleGraphNode]):
	for node in graph_nodes:
		#print("Remove " + str(bubble.get_instance_id()))
		_bubbles.erase(node._bubble)
	
	_rebuild()
	
func get_matches_of(bubble: Bubble, filter: Callable) -> Array[BubbleGraphNode]:
	var search_root: BubbleGraphNode = _bubbles[bubble]
	
	var searched: Array[BubbleGraphNode] = []
	search_root.add_matches(searched, filter)
	
	return searched

func get_orphans() -> Array[BubbleGraphNode]:
	var result_nodes: Array[BubbleGraphNode] = []
	
	var groups = _get_groups_in_list(_graphNodes)
	for group in groups:
		var is_orphaned = not group.any(func(node): return _is_touching_center(node._bubble))
		if is_orphaned:
			result_nodes.append_array(group)
	
	return result_nodes

func _get_groups_in_list(input_list: Array[BubbleGraphNode]):
	var result_groups = []
	var searched = []
	
	for node in input_list:
		if searched.has(node):
			continue
		
		var connections = get_matches_of(node._bubble, func(x): return true)
		searched.append_array(connections)
		
		result_groups.append(connections)
	
	return result_groups

func _rebuild():
	_graphNodes.clear()
	
	for bubble in _bubbles:
		if not is_instance_valid(bubble):
			print("Invalid instance in _rebuild()")
			continue
		
		var new_graph_node = BubbleGraphNode.new(bubble)
		
		for graph_node in _graphNodes:
			if _are_bubbles_connected(bubble, graph_node._bubble):
				var string = "Connecting %s with %s"
				#print(string % [graph_node._bubble.get_instance_id(), bubble.get_instance_id()])
				graph_node.connect_with_other(new_graph_node)
		
		_graphNodes.append(new_graph_node)
		_bubbles[bubble] = new_graph_node

func _are_bubbles_connected(bubble_1: Bubble, bubble_2: Bubble):
	return bubble_1.global_position.distance_squared_to(bubble_2.global_position) < CONNECT_DISTANCE_SQUARED

func _is_touching_center(bubble: Bubble):
	return bubble.global_position.length_squared() <= CENTER_RADIUS_SQUARED

class BubbleGraphNode:
	var _bubble: Bubble
	var _connections: Array[BubbleGraphNode] = []
	
	func _init(bubble: Bubble) -> void:
		_bubble = bubble
	
	func connect_with_other(other_graph_node: BubbleGraphNode):
		self._connections.append(other_graph_node)
		other_graph_node._connections.append(self)
	
	func add_matches(already_matched: Array[BubbleGraphNode], filter: Callable):
		if already_matched.has(self):
			return
		
		if not filter.call(_bubble):
			return
		
		already_matched.append(self)
		
		for connection in _connections:
			connection.add_matches(already_matched, filter)
