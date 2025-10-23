extends Node3D

func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		var mc = get_tree().root.get_node("Test/Player/ProtoController")
		print(mc)
		mc.die()
		print("entrei")
