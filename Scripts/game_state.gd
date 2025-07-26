class_name GameState
extends Node

var is_game_over: bool = false

signal game_over

func set_game_over():
	is_game_over = true
	emit_signal("game_over")
