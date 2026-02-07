extends Node

var loop_count: int = 0
const house_scale: Vector3 = Vector3(1.5, 1.5, 1.5)
var actual_scene: String

func set_actual_scene(scene: String) -> int:
	actual_scene = scene
	return 0
