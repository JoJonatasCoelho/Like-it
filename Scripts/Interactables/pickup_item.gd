extends Interactable

class_name PickupItem

@export var item_scene: PackedScene

func interact(player: Node) -> void:
	var player_controller: PlayerController = player.get_node("../../..")
	if item_scene == null || player_controller.has_held_item:
		return
	if player_controller.has_held_item:
		player_controller.drop_held_item()
	var item := item_scene.instantiate()
	if item is Item:
		player_controller.pick_up_item(item)
	# if not item?
	queue_free()
