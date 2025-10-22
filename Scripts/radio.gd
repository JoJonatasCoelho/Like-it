extends Interactable

@onready var audio_player : AudioStreamPlayer3D = $AudioStreamPlayer3D

@export var is_playing = true

func _ready():
	audio_player.stream = preload("res://Assets/audio/POL-elevator-lift2.wav")
	audio_player.play(0)

func interact(_caller):
	is_playing = !is_playing
	if is_playing:
		audio_player.play(0)
	if !is_playing:
		audio_player.stop()
