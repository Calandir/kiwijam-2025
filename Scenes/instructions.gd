extends Sprite2D

func _on_open_button_instructions_pressed() -> void:
	var _sfxPlayer = get_tree().current_scene.find_child("SFXPlayer", true)
	_sfxPlayer.play_miss_sfx()
	self.visible = true

func _on_close_button_instructions_pressed() -> void:
	var _sfxPlayer = get_tree().current_scene.find_child("SFXPlayer", true)
	_sfxPlayer.play_miss_sfx()
	self.visible = false 
