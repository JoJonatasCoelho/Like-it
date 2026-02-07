extends Item

var _light: Light3D

func _ready() -> void:
	_light = $SpotLight3D if has_node("SpotLight3D") else null
	if _light:
		_light.visible = false
	if item_name.strip_edges() == "":
		item_name = "Lanterna"

func on_use() -> void:
	_light.visible = not _light.visible
	
