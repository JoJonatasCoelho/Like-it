extends Node3D

signal checkpoint_passed(stats)

@export var world_env: WorldEnvironment
@export var water: Node3D
@export var audio : AudioStreamPlayer 

@export var has_been_passed: bool = false
@export var water_rise_amount: float = 0.5
@export var volume_increase: float = 0.0

func _on_area_3d_body_entered(body: Node3D) -> void:
	if has_been_passed:
		return

	if body is CharacterBody3D:
		# tenta obter environment com fallback
		var env = null
		if world_env and world_env.environment:
			env = world_env.environment
		else:
			# fallback para viewport environment, se existir
			if get_viewport() and get_viewport().has_method("get_environment"):
				env = get_viewport().get_environment()
			else:
				env = null

		# só cria tween se env não for null
		if env:
			var tween := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(env, "ambient_light_energy", 0.5, 2.0)
			env.fog_enabled = true
			tween.tween_property(env, "fog_density", 0.05, 2.0)
			tween.tween_property(env, "ambient_light_color", Color(0.1, 0.1, 0.15), 2.0)
		else:
			print("Checkpoint: environment não encontrado — pulando tween de ambiente")

		# water
		if water:
			var new_y = water.position.y + water_rise_amount
			var tw = create_tween()
			tw.tween_property(water, "position:y", new_y, 3.0)

		# audio
		if audio and audio is AudioStreamPlayer:
			var new_volume = audio.volume_db + volume_increase
			var tw2 = create_tween()
			tw2.tween_property(audio, "volume_db", new_volume, 3.0)

		# backdoor — use get_node_or_null para evitar erros
		var backdoor = get_node_or_null("StaticBody3D")
		backdoor.collision_layer = 1

		has_been_passed = true

		var stats = {
			"time_spent": Time.get_ticks_msec()/1000
		}
		print("oi")
		# print("tempo de jogo: ",stats.time)
		print("Checkpoint emitting from node:", self, " parent house:", get_parent(), " stats:", stats)
		emit_signal("checkpoint_passed", stats)
