extends Node2D

@export var canvas: CanvasLayer
@export var game_state: GameState

func _ready():
	game_state.game_over.connect(activate)
	canvas.visible = false

func activate():
	canvas.visible = true
