extends Button


func _on_button_down() -> void:
	var game_scene = load("res://Scenes/tash_menu.tscn")
	get_tree().change_scene_to_packed(game_scene)
