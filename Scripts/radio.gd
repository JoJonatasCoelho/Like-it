extends Interactable

@onready var audio_player : AudioStreamPlayer3D = $AudioStreamPlayer3D

func _ready():
	audio_player.stream = preload("res://Assets/audio/POL-elevator-lift2.wav")
	audio_player.play(0)

func interact(_caller):
	audio_player.playing = !audio_player.playing
	if audio_player.playing:
		audio_player.play(0)
	if !audio_player.playing:
		audio_player.stop()
