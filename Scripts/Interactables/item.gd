extends Node3D

class_name Item

@export var item_name: String = "Item"

func get_id() -> String:
	return "item: " + self.item_name

func on_pick_up(hand_socket: Node3D):
	# antes o add child dava erro
	self.reparent(hand_socket)
	transform = Transform3D.IDENTITY
	#global_transform = hand_socket.global_transform
	
func on_drop(drop_transform: Transform3D):
	var scene_root := get_tree().get_current_scene()
	self.reparent(scene_root)
	global_transform = drop_transform
	
func on_use() -> void:
	pass
