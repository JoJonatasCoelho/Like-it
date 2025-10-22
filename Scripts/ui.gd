extends CanvasLayer

@onready var photo_viewer = $PhotoViewer
@onready var label = $Label
var is_photo_open = false

func toggle_photo(texture: Texture2D):
	var player = get_tree().root.get_node("Test/Player/ProtoController")
	if is_photo_open:
		photo_viewer.visible = false
		is_photo_open = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		if player:
			label.text = ""
			player.can_look = true
			player.can_move = true
	else:
		photo_viewer.texture = texture
		photo_viewer.visible = true
		is_photo_open = true
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
		if player:
			label.text = "Aperte \"E\" para fechar"
			player.can_look = false
			player.can_move = false
