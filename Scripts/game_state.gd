class_name GameState
extends Node

var score: int = 0
var is_game_over: bool = false

signal game_over
signal score_changed

func set_game_over():
	is_game_over = true
	emit_signal("game_over")

func add_score(add_score: int):
	score += add_score
	emit_signal("score_changed", score)
