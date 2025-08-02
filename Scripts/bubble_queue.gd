class_name BubbleQueue

extends Node

var queue: Array[Bubble.BubbleType] = []
var textures: Array[TextureRect] = []

var textures_dict: Dictionary = {
	Bubble.BubbleType.Red: preload("res://Art/orb2.png"),
	Bubble.BubbleType.Blue: preload("res://Art/orb1.png"),
	Bubble.BubbleType.Green: preload("res://Art/orb3.png"),
	Bubble.BubbleType.Yellow: preload("res://Art/orb4.png"),
	Bubble.BubbleType.Purple: preload("res://Art/orb6.png"),
	Bubble.BubbleType.Brown: preload("res://Art/orb5.png"),
}

func push(bubble_type: Bubble.BubbleType):
	queue.append(bubble_type)
	_refresh()

func pop() -> Bubble.BubbleType:
	var to_return = queue.pop_front()
	_refresh()
	return to_return

func push_and_pop(bubble_type: Bubble.BubbleType) -> Bubble.BubbleType:
	queue.append(bubble_type)
	return pop()

func _refresh():
	if len(textures) == 0:
		_load_children()
	
	# Note that items are then displayed right-to-left
	# So the queue pops from the right side
	for i in range(len(textures)):
		var texture_rect = textures[i]
		if i >= len(queue):
			texture_rect.visible = false
			continue
		texture_rect.visible = true
		
		texture_rect.texture = textures_dict[queue[i]]
		

func _load_children():
	var children = get_children()
	for child in children:
		textures.append(child as TextureRect)
