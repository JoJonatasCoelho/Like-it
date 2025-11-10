extends Interactable

class_name PickupItem

@export var item_scene: PackedScene

func interact(player: Node) -> void:
	if item_scene == null:
		return
	if player.has_held_item():
		player.drop_held_item()
	var item: Node = item_scene.instantiate()
	player.pick_up(item)
	# Este nó (representação no mundo) some ao pegar
	queue_free()
