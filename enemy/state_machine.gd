extends Node
class_name StateMachine

@export var default_state: State

var current_state: State
var states: Dictionary = {}

func _ready() -> void:
	# nav mesh is not ready immediately at start, so we add a delay
	await get_tree().create_timer(0.5).timeout

	for child in get_children():
		if child is State:
			states[child.name] = child
			child.initialize()

	if default_state:
		change_state(default_state.name)

func change_state(state_name: String):
	var new_state = states.get(state_name)

	if not new_state:
		DebugGame.print_error_and_break("Invalid state_name: " + state_name)
		return

	if new_state == current_state:
		return

	if current_state:
		current_state.exit()

	current_state = new_state
	current_state.enter()

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func _on_navigation_agent_target_reached() -> void:
	if current_state:
		current_state.navigation_complete()
