extends Node

var miss_sfx := [
	load("res://Audio/miss.wav"),
]
var connect_sfx := [
	load("res://Audio/connect.wav"),
]
var spell_sfx := [
	load("res://Audio/spell.wav"),
]

func play_miss_sfx():
	play_sfx(miss_sfx[randi() % len(miss_sfx)])

func play_connect_sfx():
	play_sfx(connect_sfx[randi() % len(connect_sfx)])

func play_spell_sfx():
	play_sfx(spell_sfx[randi() % len(spell_sfx)])

func play_sfx(audio_stream: AudioStream, volume_db: float = 0.0):
	# AudioStreamPlayer can only play one sound at a time!
	# To support polyphony, we spawn an AudioStreamPlayer every time and clean it up when done.
	# https://www.reddit.com/r/godot/comments/1atc6oc/trying_to_create_a_temporary_audiostreamplayer/
	var player := AudioStreamPlayer.new()
	add_child(player)
	player.stream = audio_stream
	player.play()
	await player.finished
	player.queue_free()
