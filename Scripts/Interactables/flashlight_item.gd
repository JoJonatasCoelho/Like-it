extends Item

var _light: Light3D

func _ready() -> void:
	_light = $Light3D if has_node("Light3D") else null
	if _light:
		_light.visible = false
	if item_name.strip_edges() == "":
		item_name = "Lanterna"

	if not _light:
		return
	_light.visible = not _light.visible
