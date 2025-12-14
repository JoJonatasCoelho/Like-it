extends Node3D

class_name Item

@export var item_name: String = "Item"

func on_pick_up(hand_socket: Node3D):
	hand_socket.add_child(self)
	global_transform = hand_socket.global_transform
	
func on_drop(drop_transform: Transform3D):
	var scene_root := get_tree().get_current_scene()
	if scene_root == null:
		push_error("Item.on_drop: current_scene é null")
		return
	if get_parent():
		get_parent().remove_child(self)
	scene_root.add_child(self)
	global_transform = drop_transform
	
func on_use() -> void:
	pass
