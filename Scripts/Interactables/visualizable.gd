extends Interactable

@export var photo_texture: Texture2D
@export var animation_name: String 
@onready var ui: CanvasLayer = $"../../../UI/CanvasLayer"

func interact(_caller):
	var subtitle_animator: AnimationPlayer = ui.get_node("SubtitlesAnimation")
	ui.toggle_photo(photo_texture)
	subtitle_animator.play(animation_name)
