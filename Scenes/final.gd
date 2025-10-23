extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_body_entered(body: Node3D) -> void:
		if body is CharacterBody3D:
			body.die() 
			await get_tree().create_timer(4.6).timeout
			get_tree().quit()
