extends Node3D

@onready var interaction_raycast : RayCast3D = $"../RayCast3D"
@onready var interaction_label : Label = $"../../Interaction Label"
@export var player: PlayerController
var interaction_is_reset : bool = true

func _process(_delta):
	if interaction_raycast.is_colliding():
		var interactable = interaction_raycast.get_collider()
		interaction_is_reset = false
		if interactable != null and interactable.has_method("interact"):
			interaction_label.text = "Aperte \"E\" para interagir."
		else:
			interaction_label.text = "Estranho..."
	else:
		if !interaction_is_reset:
			interaction_label.text = ""
			interaction_is_reset = true

func _input(event):
	# to-do: consertar a forma que o player eh passado nas funçoes de interaction_component
	if event.is_action_pressed("interact"):
		if interaction_raycast.is_colliding():
			var interactable = interaction_raycast.get_collider()
			if interactable.has_method("interact"):
				if interactable.is_interacting:
					return
				get_viewport().set_input_as_handled()
				interactable.is_interacting = true
				interaction_label.text = ""  
				await interactable.interact(player)
				interactable.is_interacting = false
