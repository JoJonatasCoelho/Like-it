extends Area3D

@export var SFX: AudioStream

func _on_body_entered(body: Node3D) -> void:
		if body is CharacterBody3D:
			var sfx_player: AudioStreamPlayer = $"../Audio/SFX"
			sfx_player.stream = SFX
			
			sfx_player.play(3)
			body.die() 
			await get_tree().create_timer(4.6).timeout
			get_tree().quit()
