extends Node3D

@onready var held_item: EquippedItem

func equip(item: EquippedItem):
	if(item is not Null):
		held_item = item
	else:
		print("assim naaaao bobinho")

func use_equipped(held_item: EquippedItem):
	held_item.use()
	
func drop_equipped(held_item: EquippedItem):
	held_item.drop()
