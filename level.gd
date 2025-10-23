extends Node3D

@onready var player: CharacterBody3D = $Player/ProtoController
@onready var player_animator: AnimationPlayer = $Player/ProtoController/PlayerBody/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.can_move = false
	player.can_look = false
	player_animator.play("standingUp")
	await get_tree().create_timer(11.4).timeout
	player.can_move = true
	player.can_look = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
