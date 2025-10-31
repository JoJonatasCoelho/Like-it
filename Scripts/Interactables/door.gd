extends Interactable

@export var is_open = false
@onready var animator = $AnimationPlayer

func interact(_caller):
	if !is_open:
		animator.play("abrir_porta")
		await get_tree().create_timer(1).timeout

	else: 
		animator.play("close_door")
	is_open = !is_open
	
	
