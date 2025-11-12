extends Item

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	pass

func interact(_caller: Node3D):
	print(_caller.get_node(".."))
	
