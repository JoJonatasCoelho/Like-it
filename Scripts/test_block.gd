extends Interactable

@onready var animator = $"../AnimationPlayer"

func interact(_caller):
	animator.play("abrir_porta")
	#queue_free()
