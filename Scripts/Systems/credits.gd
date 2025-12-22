extends Control

const MENU_SCENE: String = "res://Scenes/UI/menu.tscn"

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file(MENU_SCENE)
