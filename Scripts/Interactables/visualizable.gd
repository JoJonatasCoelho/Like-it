extends Interactable

@export var photo_texture: Texture2D
@export var animation_name: String 
var ui: CanvasLayer

func _ready() -> void:
	ui = get_tree().root.get_node("/root/" + get_tree().current_scene.name + "/UI/CanvasLayer")	
	print("UI: ", ui)
	print(get_tree().current_scene.name)

func interact(_caller):
	var subtitle_animator: AnimationPlayer = ui.get_node("SubtitlesAnimation")
	print("Em visualizable: ", photo_texture)
	ui.toggle_photo(photo_texture)
	subtitle_animator.play(animation_name)
