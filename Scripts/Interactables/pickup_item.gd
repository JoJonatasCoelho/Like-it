extends Interactable

class_name PickupItem

@export var item_scene: PackedScene

func interact(player: Node) -> void:
	var player_controller: CharacterBody3D = player.get_node("..")
	if item_scene == null || player_controller.has_held_item:
		return
	if player.has_held_item():
		player.drop_held_item()
	var item := item_scene.instantiate()
	# if not item?
	player.pick_up(item)
	queue_free()
