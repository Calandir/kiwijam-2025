extends Label

func _ready():
	text = "Score: 0"
	
	var test = get_tree().current_scene.find_child("GameState", true)
	
	test.score_changed.connect(on_score_changed)

func on_score_changed(new_value: int):
	text = "Score: " + str(new_value)
