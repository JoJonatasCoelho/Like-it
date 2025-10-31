extends Control


func _ready() -> void:
	$VBoxContainer/StartButton.grab_focus()

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/map.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_credits_button_pressed() -> void:
	pass # Ainda precisa implementar 
