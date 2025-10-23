extends Node3D

@onready var interaction_raycast : RayCast3D = $"../RayCast3D"
@onready var interaction_label : Label = $"../../Interaction Label"
var interaction_is_reset : bool = true
var is_interacting : bool = false

func _process(_delta):
	if interaction_raycast.is_colliding():
		var interactable = interaction_raycast.get_collider()
		interaction_is_reset = false
		if interactable != null and interactable.has_method("interact"):
			interaction_label.text = "Aperte \"E\" para interagir."
		else:
			interaction_label.text = "Vish, caiu no else"

	else:
		if !interaction_is_reset:
			interaction_label.text = ""
			interaction_is_reset = true

func _input(event):
	if is_interacting:
		return
		
	if event.is_action_pressed("interact"):
		if interaction_raycast.is_colliding():
			var interactable = interaction_raycast.get_collider()
			if interactable.has_method("interact"):
				is_interacting = true
				interaction_label.text = ""  
				await interactable.interact(self)
				is_interacting = false
