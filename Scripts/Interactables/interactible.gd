extends Node3D

class_name Interactable 

@export var is_interacting = false

func interact(_caller):
	print(_caller.get_node(".."))
