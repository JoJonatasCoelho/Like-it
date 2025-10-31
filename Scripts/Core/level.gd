extends Node3D

@onready var player: CharacterBody3D = get_tree().root.get_node("Map/Player/ProtoController") 
@onready var player_animator: AnimationPlayer = get_tree().root.get_node("Map/Player/ProtoController/PlayerBody/AnimationPlayer") 
@onready var subtitles_animator: AnimationPlayer = get_tree().root.get_node("Map/UI/CanvasLayer/SubtitlesAnimation")

func _ready() -> void:
	player.can_move = false
	player.can_look = false
	player_animator.play("standingUp")
	subtitles_animator.play("subtitles")
	await get_tree().create_timer(11.4).timeout
	player_animator.play("RESET")
	player.can_move = true
	player.can_look = true
