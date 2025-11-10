extends Node3D

class_name Item

@export var item_name: String = "Item"

func equip(hand: Node3D):
	var _original_parent: Node3D = get_parent()
	reparent(hand)
	
func drop(player: Node3D):
	pass
	
	
