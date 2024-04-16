extends Node
class_name State

@export_node_path("AIController") var controller_path: NodePath

var active: bool
var state_machine: StateMachine
var controller: AIController

func initialize() -> void:
	state_machine = get_parent()
	controller = get_node(controller_path)

func enter() -> void:
	active = true

func exit() -> void:
	active = false

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	pass

func navigation_complete() -> void:
	pass

func random_offset() -> Vector3:
	var offset = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()
	return offset
