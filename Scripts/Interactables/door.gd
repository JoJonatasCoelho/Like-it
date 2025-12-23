extends Interactable

@export var is_open = false
@onready var animator = $AnimationPlayer

func interact(_caller):
	var item_slot: ItemSlot = get_node("../ItemSlot")
	if item_slot:
		if item_slot.check_item(_caller.get_node("../../..")):
			open_door()
		else:
			# to-do: fazer isso aqui depois :P
			print("tu nao tem o item n kkkkkkk")
	else:
		open_door()

func open_door():
	if !is_open:
		animator.play("abrir_porta")
		await get_tree().create_timer(1).timeout

	else: 
		animator.play("close_door")
	is_open = !is_open
	
	
