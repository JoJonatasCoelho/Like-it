extends Node

@export var house_scenes: Array[PackedScene] # Array com PackedScenes das casas possíveis
@export var house_anchor: Node3D # Nó pai onde as houses serão adicionadas, 
							# talvez trocar pra Vector2 e usar pra recalcular onde instanciar a casa
@export var start_index: int = 0

var house_current: Node3D = null
var house_next: Node3D = null
var loop_count: int = 0 # Talvez variavel global

func _ready():
	# instancia a casa inicial e a próxima
	house_current = _instantiate_house(start_index)
	_align_house_to_anchor_entry(house_current, house_anchor.global_transform)
	_connect_house_checkpoint(house_current)

	var next_idx = _choose_next_house(null, 0)
	house_next = _instantiate_house(next_idx)
	_align_house_to_exit_of(house_next, house_current)
	_connect_house_checkpoint(house_next)

func _instantiate_house(index: int) -> Node3D:
	var h = house_scenes[index].instantiate()
	house_anchor.add_child(h)
	return h

func _connect_house_checkpoint(house: Node3D) -> void:
	# conecta o sinal checkpoint_passed da house ao _on_house_entered; bindamos a referência da house
	if house.has_signal("checkpoint_passed"):
		house.connect("checkpoint_passed", Callable(self, "_on_house_entered"), [house])

func _on_house_entered(stats: Dictionary, entered_house: Node) -> void:
	# Só reagimos quando o jogador entrou na house_next (ou seja, avançou)
	if entered_house != house_next:
		return

	loop_count += 1

	# 1) decide terceira casa usando stats (tempo, interações, items)
	var third_idx = _choose_next_house(stats, loop_count)
	var house_third = _instantiate_house(third_idx)

	# 2) alinha a terceira com a saída da house_next
	_align_house_to_exit_of(house_third, house_next)

	# 3) conecta o checkpoint da terceira
	_connect_house_checkpoint(house_third)

	# 4) tranca a passagem de volta na house_next (para evitar 'cair no void')
	if house_next.has_method("lock_backdoor"):
		house_next.lock_backdoor()

	# 5) remove a house_current (a primeira)
	if house_current:
		# opcional: desconectar sinais / animação de fade antes de queue_free
		house_current.queue_free()

	# 6) atualiza ponteiros
	house_current = house_next
	house_next = house_third

func _choose_next_house(stats: Dictionary, loop_count: int) -> int:
	# Exemplo de heurística — adapte livremente:
	# - Se o jogador foi rápido -> casa mais difícil (index 2)
	# - Se usou item X -> casa com evento (index 3)
	# - caso contrário, ciclar entre 0 e 1
	if stats != null and stats.has("time_spent"):
		var t = stats["time_spent"]
		if t < 20.0:
			return min(2, house_scenes.size() - 1)  # casa mais 'hard'
	if stats != null and stats.has("items_used"):
		var items = stats["items_used"]
		if "key_of_fire" in items:
			return min(3, house_scenes.size() - 1)
	# fallback simples
	return (loop_count + start_index + randi()) % house_scenes.size()

# --- alinhamento ---
func _align_house_to_anchor_entry(house: Node3D, desired_global: Transform3D) -> void:
	var entry = house.get_node("Entry") if house.has_node("Entry") else null
	if entry:
		# next.global = desired_global * inverse(entry.transform)
		house.global_transform = desired_global * entry.transform.affine_inverse()
	else:
		house.global_transform = desired_global

func _align_house_to_exit_of(house_to_align: Node3D, reference_house: Node3D) -> void:
	var ref_exit = reference_house.get_node("Exit") if reference_house.has_node("Exit") else null
	var entry = house_to_align.get_node("Entry") if house_to_align.has_node("Entry") else null
	if ref_exit and entry:
		var desired = ref_exit.global_transform
		house_to_align.global_transform = desired * entry.transform.affine_inverse()
