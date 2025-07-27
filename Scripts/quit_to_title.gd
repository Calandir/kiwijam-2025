extends Button


func _on_pressed() -> void:
	var _sfxPlayer = get_tree().current_scene.find_child("SFXPlayer", true)
	_sfxPlayer.play_miss_sfx()
	var game_scene = load("res://Scenes/tash_menu.tscn")
	get_tree().change_scene_to_packed(game_scene)


func _on_mouse_entered() -> void:
	var _sfxPlayer = get_tree().current_scene.find_child("SFXPlayer", true)
	_sfxPlayer.play_sparkle_sfx()
