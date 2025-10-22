extends Node3D

@onready var cut_scene: AnimationPlayer = $Cutscene

func _ready() -> void:
	cut_scene.play("intro")
	
