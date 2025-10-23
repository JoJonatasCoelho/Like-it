extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/StartButton.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/map.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_credits_button_pressed() -> void:
	pass # Ainda precisa implementar 
