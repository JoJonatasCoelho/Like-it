extends Node3D

class_name 	Inventory

@onready var held_item: Item

func equip(item: Item):
	if(item != null):
		held_item = item
		print("equipado")
	else:
		print("assim naaaao bobinho")

func use_equipped():
	held_item.on_use()
	
func drop_equipped():
	held_item.drop()
