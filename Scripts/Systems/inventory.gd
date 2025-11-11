extends Node3D

@onready var held_item: Item

func equip(item: Item):
	if(item != null):
		held_item = item
	else:
		print("assim naaaao bobinho")

func use_equipped():
	held_item.use()
	
func drop_equipped():
	held_item.drop()
