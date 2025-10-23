extends Node3D

@onready var player: CharacterBody3D = get_tree().root.get_node("Map/Player/ProtoController") 
@onready var player_animator: AnimationPlayer = get_tree().root.get_node("Map/Player/ProtoController/PlayerBody/AnimationPlayer") 

func _ready() -> void:
	player.can_move = false
	player.can_look = false
	player_animator.play("standingUp")
	await get_tree().create_timer(11.4).timeout
	player.can_move = true
	player.can_look = true
