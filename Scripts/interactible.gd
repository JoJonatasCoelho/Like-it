extends Node3D

class_name Interactable 

@export var is_interacting = false

# Função genérica pra interagir com objetos (sobrescrever)
func interact(_caller):
	print("Objeto interagido.")
