extends Node3D

signal checkpoint_passed(stats)

@export var checkpoint_node_path: NodePath = "" # Adicionar path do checkpoint
@export var entry_path: NodePath = "" # Adicionar path da Entry
@export var exit_path: NodePath = "" # Adicionar path da Exit

var interactions := {}     # Mapa de interações dentro da casa
var items_used : Array[Item] = []       # Lista de itens usados dentro da casa
var spawn_time := 0.0

func _ready():
	spawn_time = Time.get_ticks_msec()/1000
	# Conectar o checkpoint local para reemitir pro LoopManager
	if has_node(checkpoint_node_path):
		var checkpoint = get_node(checkpoint_node_path)
		if checkpoint.has_signal("checkpoint_passed"):
			checkpoint.connect("checkpoint_passed", Callable(self, "_on_local_checkpoint_passed"))

func _on_local_checkpoint_passed(checkpoint_stats: Dictionary) -> void:
	# Agrega dados locais (tempo, interações, items) e reemite
	var time_spent = Time.get_ticks_msec()/1000 - spawn_time
	var stats = {
		"time_spent": time_spent,
		"interactions": interactions.duplicate(),
		"items_used": items_used.duplicate(),
	}
	# Mescla info do checkpoint (se existir)
	for k in checkpoint_stats.keys():
		stats[k] = checkpoint_stats[k]
	emit_signal("checkpoint_passed", stats)

# API para o LoopManager usar
func get_entry_node() -> Node3D:
	return get_node(entry_path) if has_node(entry_path) else null

func get_exit_node() -> Node3D:
	return get_node(exit_path) if has_node(exit_path) else null

func lock_backdoor() -> void:
	# ATIVAR A COLISAO DA PAREDE DO BANHEIRO
	pass
