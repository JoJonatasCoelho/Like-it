extends Node

# Pode arrastar PackedScenes no Inspector OU usar paths de String (como no teu exemplo)
@export var house_scenes: Array = [
	"res://Scenes/Levels/houses/house_0.tscn",
	"res://Scenes/Levels/houses/house_1.tscn",
	"res://Scenes/Levels/houses/house_2.tscn",
	"res://Scenes/Levels/houses/house_3.tscn",
	"res://Scenes/Levels/houses/house_4.tscn"
]
@export var house_anchor: Node3D
@export var start_index: int = 0

@export var use_linear_layout: bool = true # casas em corredor on
@export var layout_step: Vector3 = Vector3(6.3, 0, 0)  # delta (X, Z) entre casas (cada step)
@export var spawn_origin_offset: Vector3 = Vector3(0, 0, 0) # offset inicial (X,Z) relativo ao anchor

const DEFAULT_MANUAL_CURRENT_NAME := "House"
const DEFAULT_MANUAL_NEXT_NAME := "House1"

var house_current: Node3D = null
var house_next: Node3D = null

var current_scene_idx: int = -1
var next_scene_idx: int = -1

var next_spawn_index: int = 0

func _ready() -> void:
	GlobalVars.loop_count = 0
	if house_anchor == null:
		house_anchor = get_parent() as Node3D
		if house_anchor == null:
			push_error("LoopManager: defina house_anchor ou coloque o LoopManager como filho do nó pai das houses.")
			return

	var manual_current := house_anchor.get_node_or_null(DEFAULT_MANUAL_CURRENT_NAME)
	var manual_next := house_anchor.get_node_or_null(DEFAULT_MANUAL_NEXT_NAME)

	if manual_current and manual_next:
		house_current = manual_current
		house_next = manual_next
		print("LoopManager: usando casas já instanciadas: ", house_current.name, ", ", house_next.name)
		return

	if house_scenes.size() == 0:
		push_error("LoopManager: house_scenes está vazio!")
		return

	current_scene_idx = start_index % house_scenes.size()
	next_scene_idx = (start_index + 1) % house_scenes.size()
	next_spawn_index = 2

	house_current = _instantiate_house(current_scene_idx, 0)
	_connect_house_checkpoint(house_current)

	house_next = _instantiate_house(next_scene_idx, 1)
	_connect_house_checkpoint(house_next)


func _instantiate_house(idx: int, spawn_index: int = -1) -> Node3D:
	#print("_instantiate_house: idx:", idx, " candidate:", house_scenes[idx])
	if house_scenes.size() == 0:
		return null
	idx = idx % house_scenes.size()

	var candidate = house_scenes[idx]
	var packed: PackedScene = null
	# suporte ao array de varios formatos?
	if candidate is PackedScene:
		packed = candidate
	elif typeof(candidate) == TYPE_STRING:
		packed = ResourceLoader.load(candidate)
		if packed == null:
			push_error("LoopManager: falha ao carregar PackedScene do path: %s" % str(candidate))
			return null
	else:
		if candidate and candidate is Resource:
			packed = candidate
		else:
			push_error("LoopManager: house_scenes[%d] não é PackedScene nem String" % idx)
			return null

	var inst = packed.instantiate() as Node3D
	if not inst:
		push_error("LoopManager: instantiate retornou null para idx %d" % idx)
		return null

	# adiciona deferido para evitar erro "Parent node is busy setting up children"
	house_anchor.call_deferred("add_child", inst)

	# posicione também deferido para garantir que o nodo já esteja no scene tree
	var spawn_idx = spawn_index if spawn_index >= 0 else next_spawn_index
	call_deferred("_deferred_post_spawn", inst, spawn_idx)
	#print("_instantiate_house: instantiated (deferred add) ->", inst.name)
	return inst

func _deferred_post_spawn(inst: Node3D, spawn_idx: int) -> void:
	if not is_instance_valid(inst):
		return

	# força um nome legível se estiver vazio
	if inst.name == "" or inst.name.begins_with("@Node3D"):
		inst.name = "House_inst_" + str(next_spawn_index)  

	# debug
	#print("deferred_post_spawn: spawned:", inst.name, " spawn_idx:", spawn_idx, " anchor:", house_anchor.name)

	inst.scale = GlobalVars.house_scale

	# posiciona
	if use_linear_layout:
		_align_house_linear_to_entry(inst, spawn_idx)
	else:
		_align_house_to_anchor_entry(inst, house_anchor.global_transform)

	#print("deferred_post_spawn: positioned:", inst.name, inst.global_transform.origin)

# Helper: procura recursivamente um nó que possua certo signal
func _find_node_with_signal(root: Node, signal_name: String) -> Node:
	if not root:
		return null
	# procura recursivamente nas crianças primeiro (prioriza emissor real)
	for child in root.get_children():
		if child is Node:
			var found := _find_node_with_signal(child, signal_name)
			if found:
				return found
	# se nada nas crianças, verifica o próprio nó
	if root.has_signal(signal_name):
		return root
	return null


# Helper: procura recursivamente um nó do tipo dado (ex: Area3D)
func _find_area3d(root: Node) -> Area3D:
	if not root:
		return null
	if root is Area3D:
		return root
	for child in root.get_children():
		if child is Node:
			var found := _find_area3d(child)
			if found:
				return found
	return null

func _connect_house_checkpoint(house: Node3D) -> void:
	if not house:
		return

	# procura o nó que emite "checkpoint_passed"
	var emitter: Node = _find_node_with_signal(house, "checkpoint_passed")
	if emitter:
		# conecta o emitter a um wrapper que loga e delega
		emitter.connect(
			"checkpoint_passed",
			Callable(self, "_on_emitter_checkpoint").bind(emitter, house)
		)
		#print("[LoopManager] connected emitter:", emitter.name, "in house:", house.name)
		return

	# fallback: procura Area3D e conecta body_entered
	var area := _find_area3d(house)
	if area:
		area.connect(
			"body_entered",
			Callable(self, "_on_area_body_entered").bind(house)
		)
		print("[LoopManager] connected Area3D.body_entered:", area.name, "in house:", house.name)
		return

	print("[LoopManager] atenção — nenhuma Checkpoint/Area encontrada em ", house.name)

func _on_emitter_checkpoint(stats: Dictionary, emitter: Node, bound_house: Node) -> void:
	print("_on_emitter_checkpoint -> emitter:", emitter, " bound_house:", bound_house, " stats:", stats)
	# agora delega para a função normal, passando o `bound_house` como a house "entrante"
	_on_house_entered(stats, bound_house)


func _on_area_body_entered(body: Node, house: Node) -> void:
	if body is CharacterBody3D:
		_on_house_entered({"time_spent":0}, house)

func _on_house_entered(stats: Dictionary, entered_house: Node) -> void:
	#print("_on_house_entered called. entered_house:", entered_house, " house_next:", house_next)
	# se entered_house for Node, imprime nomes
	if entered_house and entered_house is Node:
		print("entered_house.name:", entered_house.name)
	if house_next:
		print("house_next.name:", house_next.name)
	# reagimos apenas quando a house que entrou é a 'next' (avançou)
	if entered_house != house_next:
		print(">>> Ignoring checkpoint: entered isn't house_next")
		return

	GlobalVars.loop_count += 1
	print(GlobalVars.loop_count)
	print("LoopManager: entrou em next:", entered_house.name)

	# decide terceira casa
	var third_idx = _choose_next_house(stats, GlobalVars.loop_count)
	var house_third = _instantiate_house(third_idx, next_spawn_index)
	if not house_third:
		push_error("LoopManager: falha ao instanciar terceira house.")
		return

	# se não estiver usando layout linear, alinha pela exit do house_next (mantendo compatibilidade)
	if not use_linear_layout:
		_align_house_to_exit_of(house_third, house_next)

	_connect_house_checkpoint(house_third)

	# tranca backdoor se implementado no house_next (o usuário disse que já tem essa mecânica)
	if house_next and house_next.has_method("lock_backdoor"):
		house_next.lock_backdoor()

	# remove a primeira casa (apenas agora)
	if house_current:
		house_current.queue_free()

	# atualizar ponteiros e índices
	house_current = house_next
	current_scene_idx = next_scene_idx

	house_next = house_third
	next_scene_idx = third_idx

	# incrementamos o índice linear para o próximo spawn
	next_spawn_index += 1

# heurística simples
func _choose_next_house(stats: Dictionary, loop_count: int) -> int:
	# Segurança básica
	if house_scenes.size() == 0:
		return -1
	
	var time_spent = 0.0
	var items_held = []
	if stats != null:
		time_spent = stats.get("time_spent", 0.0)
		items_held = stats.get("items_used", [])

	
	var max_idx = house_scenes.size() - 1

	# 1. FINAL / PESADELO ETERNO (House 4)
	# Se o jogador já passou de 3 loops, ele fica preso na última casa (House 4)
	if loop_count >= 3:
		# Se ele tiver um item específico,  fazer algo diferente
		# por padrão, mantém ele no pesadelo.
		return 4 

	# 2. SPEEDRUNNER / MEDO (Pula etapas)
	# Se o jogador correu muito rápido na House 1 ou 2 (menos de 15s),
	# o "Emotions" percebe o medo e joga ele direto para a casa perigosa (House 3)
	if loop_count >= 1 and time_spent < 15.0:
		print("LoopManager: Jogador com pressa. Pulando para o perigo.")
		return 3

	# 3. PUZZLE DE LORE (House 2)
	# Se ele pegou a "key" (ou outro item de lore), garantimos que ele 
	# vá para a casa que tem a fechadura correspondente (vamos supor que é a House 2)
	if "key" in items_held and loop_count < 2:
		return 2

	# Loop 0 (Intro) -> Próxima será 1
	# Loop 1 (Estranho) -> Próxima será 2
	# Loop 2 (Tenso) -> Próxima será 3
	# Loop 3 (Perigo) -> Próxima será 4
	var next_logical_index = loop_count + 1
	
	# Garante que não estoure o array (clamp entre 0 e 4)
	return clampi(next_logical_index, 0, max_idx)

# posiciona tal que o Entry da house coincida com a posição linear (origin + layout_step * spawn_index)
func _align_house_linear_to_entry(house: Node3D, spawn_index: int) -> void:
	if not house:
		return
	var entry = house.get_node_or_null("Entry")
	# calcula posição 2D (X,Z) relativas ao anchor
	var origin2 = spawn_origin_offset
	var offset2 = layout_step * float(spawn_index)  # Vector2 * scalar
	var desired2 = origin2 + offset2
	# transforma pra Vector3 (X, Y=0, Z)
	var desired_global_pos = house_anchor.global_transform.origin + Vector3(desired2.x, 0.0, desired2.y)
	# cria transform desejado (mantemos rotação igual à anchor)
	var desired_transform = Transform3D(house_anchor.global_transform.basis, desired_global_pos)
	if entry:
		house.global_transform = desired_transform * entry.transform.affine_inverse()
	else:
		house.global_transform = desired_transform

func _align_house_to_anchor_entry(house: Node3D, desired_global: Transform3D) -> void:
	if not house:
		return
	var entry = house.get_node_or_null("Entry")
	if entry:
		house.global_transform = desired_global * entry.transform.affine_inverse()
	else:
		house.global_transform = desired_global

func _align_house_to_exit_of(house_to_align: Node3D, reference_house: Node3D) -> void:
	if not house_to_align or not reference_house:
		return
	var ref_exit = reference_house.get_node_or_null("Exit")
	var entry = house_to_align.get_node_or_null("Entry")
	if ref_exit and entry:
		var desired = ref_exit.global_transform
		house_to_align.global_transform = desired * entry.transform.affine_inverse()
