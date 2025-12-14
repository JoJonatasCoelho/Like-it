extends Interactable

class_name PickupItem

@export var item_scene: PackedScene

func interact(player: Node) -> void:
	var player_controller: PlayerController = player.get_node("../../..")
	if item_scene == null:
		return
	var item := item_scene.instantiate()
	if not (item is Item):
		item.queue_free()
		queue_free()
		return
	if player_controller.has_held_item:
		player_controller.drop_held_item()
	player_controller.pick_up_item(item)
	# if not item?
	queue_free()
