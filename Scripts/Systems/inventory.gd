extends Node3D

class_name 	Inventory

@onready var held_item: Item = null

func equip(item: Item):
	if(item != null):
		held_item = item
		print("item equipado: " + item.get_id())
	else:
		print("Erro ao equipar o item")

func use_equipped():
	if (held_item != null):
		held_item.on_use()
	else:
		print("nenhum item equipado")
	
func drop_equipped() -> Item:
	if (held_item != null):
		var dropped = held_item
		held_item = null
		return dropped
	print("nenhum item equipado")
	return null
