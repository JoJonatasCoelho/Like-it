extends Item

func _ready() -> void:
	if item_name.strip_edges() == "":
		item_name = "Chave"
