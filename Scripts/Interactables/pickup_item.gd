extends Interactable

class_name PickupItem

# to-do: settar a desgraça do nome dos itens pegaveis
@export var item_scene: PackedScene

func interact(player: PlayerController) -> void:
	if item_scene == null:
		return
	var item := item_scene.instantiate()
	if not (item is Item):
		item.queue_free()
		queue_free()
		return
	if player.has_held_item:
		player.drop_held_item()
	player.pick_up_item(item)
	# if not item?
	queue_free()
