extends Area3D

@onready var world_env: WorldEnvironment = get_node("/root/Test/WorldEnvironment")
@onready var water: Node3D = get_node("/root/Test/Water")
@onready var audio = get_node("/root/Test/Audio/BGM")

@export var has_been_passed: bool = false
@export var water_rise_amount: float = 0.5
@export var volume_increase: float = 0.0

func _on_body_entered(body: Node3D) -> void:
	if !has_been_passed:
		if body is CharacterBody3D:
			print("ENTROOOU")
			var env := world_env.environment
			var tween := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

			tween.tween_property(env, "ambient_light_energy", 0.5, 2.0)

			env.fog_enabled = true
			tween.tween_property(env, "fog_density", 0.05, 2.0)

			tween.tween_property(env, "ambient_light_color", Color(0.1, 0.1, 0.15), 2.0)
			has_been_passed = true
			
			if water:
				var new_y = water.position.y + water_rise_amount
				tween.tween_property(water, "position:y", new_y, 3.0)
				print("entrou 2")
				
			
			if audio is AudioStreamPlayer3D or audio is AudioStreamPlayer:
				print("Volume atual: ", audio.volume_db)
				print("Volume increase: ", volume_increase)
				
				var new_volume = audio.volume_db + volume_increase
				print("Volume novo: ", new_volume)

				tween.tween_property(audio, "volume_db", new_volume, 3.0)
				
