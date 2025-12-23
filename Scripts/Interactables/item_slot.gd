extends Interactable

class_name ItemSlot

@export var missing_item_text: String = ""

@export var required_item_name: String = ""

func check_item(player: PlayerController) -> bool:
	var hand = player.get_node("Hand")
	if hand.get_child_count() == 0:
		print("deu false negeba")
		return false
		
	var item: Item = hand.get_child(0)
	if item.item_name == required_item_name:
		return true
	else:
		return false
