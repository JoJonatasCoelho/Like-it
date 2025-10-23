extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_body_entered(body: Node3D) -> void:
		if body is CharacterBody3D:
			var mc = get_tree().root.get_node("Map/Player/ProtoController")
			mc.die() 
			get_tree().quit()
