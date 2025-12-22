extends Control

const MAP_SCENE: String = "res://Scenes/Levels/map.tscn"
const CREDIT_SCENE: String = "res://Scenes/UI/credits.tscn"


func _ready() -> void:
	#$VBoxContainer/StartButton.grab_focus()
	pass

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file(MAP_SCENE)

func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file(CREDIT_SCENE)
	
func _on_exit_button_pressed() -> void:
	get_tree().quit()
