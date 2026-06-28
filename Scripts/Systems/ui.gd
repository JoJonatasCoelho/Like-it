extends CanvasLayer

@onready var photo_viewer = $PhotoViewer
@onready var label = $Label
@onready var subtitle = $Subtitles

var is_photo_open = false
var dialogue_playing = false

@export var player: CharacterBody3D

func _input(event):
	if is_photo_open and event.is_action_pressed("interact"):
		get_viewport().set_input_as_handled()
		toggle_photo()

func toggle_photo(texture: Texture2D = null):
	print("no toggle foto:", texture)
	if is_photo_open:
		photo_viewer.visible = false
		is_photo_open = false
		if player:
			label.text = ""
			player.can_look = true
			player.can_move = true
			player.capture_mouse() 

	else:
			photo_viewer.texture = texture
			photo_viewer.visible = true
			is_photo_open = true
			
			if player:
				label.text = "Aperte \"E\" para fechar"
				player.can_look = false
				player.can_move = false
				player.release_mouse()
