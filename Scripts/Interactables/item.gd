extends Node3D

class_name Item

@export var item_name: String = "Item"

func on_pick_up(hand_socket: Node3D):
	hand_socket.add_child(self)
	global_transform = hand_socket.global_transform
	
func on_drop():
	pass
	
func on_use() -> void:
	pass
