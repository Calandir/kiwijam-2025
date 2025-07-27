class_name BubbleGraph

const CONNECT_DISTANCE_SQUARED = 90 * 90

var _bubbles = {}
var _graphNodes: Array[BubbleGraphNode] = []

func add(bubble: Bubble):
	if _bubbles.has(bubble):
		return
	
	#print("Add " + str(bubble.get_instance_id()))
	_bubbles[bubble] = ""
	_rebuild()

func remove(bubbles: Array[Bubble]):
	for bubble in bubbles:
		#print("Remove " + str(bubble.get_instance_id()))
		_bubbles.erase(bubble)
	
	_rebuild()
	
func get_matches_of(bubble: Bubble, filter: Callable) -> Array[Bubble]:
	var search_root: BubbleGraphNode = _bubbles[bubble]
	
	var searched: Array[BubbleGraphNode] = []
	search_root.add_matches(searched, filter)
	
	var results: Array[Bubble] = []
	for result in searched:
		results.append(result._bubble)
	
	return results
	

func _rebuild():
	_graphNodes.clear()
	
	for bubble in _bubbles:
		if bubble is not Bubble:
			continue
		
		var new_graph_node = BubbleGraphNode.new(bubble)
		
		for graph_node in _graphNodes:
			var is_connected: bool = graph_node._bubble.global_position.distance_squared_to(bubble.global_position) < CONNECT_DISTANCE_SQUARED
			if is_connected:
				var string = "Connecting %s with %s"
				#print(string % [graph_node._bubble.get_instance_id(), bubble.get_instance_id()])
				graph_node.connect_with_other(new_graph_node)
		
		_graphNodes.append(new_graph_node)
		_bubbles[bubble] = new_graph_node




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
