extends Interactable

@export var photo_texture: Texture2D

func interact(_caller):
	var ui = get_tree().root.get_node("Level/UI/CanvasLayer")
	if ui is CanvasLayer:
		ui.toggle_photo(photo_texture)
