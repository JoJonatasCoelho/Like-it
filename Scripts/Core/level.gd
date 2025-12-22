extends Node3D

#@onready var player: CharacterBody3D = $Player/ProtoController
@export var player: CharacterBody3D
#@onready var player_animator: AnimationPlayer = $Player/ProtoController/PlayerBody/AnimationPlayer
@export var player_animator: AnimationPlayer
#@onready var subtitles_animator: AnimationPlayer = $UI/CanvasLayer/SubtitlesAnimation
@export var subtitles_animator: AnimationPlayer

func _ready() -> void:
	player.can_move = false
	player.can_look = false
	player_animator.play("standingUp")
	subtitles_animator.play("subtitles")
	await get_tree().create_timer(11.4).timeout
	player.can_move = true
	player.can_look = true
	player_animator.play("RESET")
