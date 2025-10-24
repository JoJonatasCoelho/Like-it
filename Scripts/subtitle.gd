extends Interactable

@export var dialogue: String

func interact(_caller):
	var ui = get_tree().root.get_node("Test/UI/CanvasLayer")
	if ui is CanvasLayer:
		ui.show_dialogue(dialogue)
			
