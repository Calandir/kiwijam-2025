extends Node2D

@export var canvas: CanvasLayer

func _ready():
	canvas.visible = false

func activate():
	canvas.visible = true
