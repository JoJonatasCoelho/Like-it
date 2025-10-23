extends Interactable

@onready var animator = $AnimationPlayer

func interact(_caller):
	animator.play("abrir_porta")
	await get_tree().create_timer(5.0).timeout
	animator.play("close_door")
	await get_tree().create_timer(1).timeout
	
