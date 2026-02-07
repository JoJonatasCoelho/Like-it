extends Interactable

class_name PickupItem

# to-do: settar a desgraça do nome dos itens pegaveis
#@export var item_scene: PackedScene
@export var item: Item

func _ready() -> void:
	if not item:
		push_error("Pickup_item sem item")

func interact(player: PlayerController) -> void:
	if item == null:
		push_error("Item não settado")
		return
	if player.has_held_item:
		player.drop_held_item()
	player.pick_up_item(item)
	# if not item?
	#queue_free()
