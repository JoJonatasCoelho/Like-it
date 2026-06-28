extends Interactable

@onready var audio_player : AudioStreamPlayer3D = $AudioStreamPlayer3D

func _ready():
	audio_player.play(0)

func interact(_caller):
	if audio_player.playing:
		audio_player.stop()
	else:
		audio_player.play(0)
