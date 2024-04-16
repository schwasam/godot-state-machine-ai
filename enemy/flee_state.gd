extends State

@export var flee_distance: float = 6.0

func enter() -> void:
	super.enter()
	controller.is_running = true
	flee()

func exit() -> void:
	super.exit()
	controller.is_running = false

func flee() -> void:
	var player_direction = (controller.player.position - controller.position).normalized()
	var move_position = controller.position - (player_direction * flee_distance)
	controller.move_to_position(move_position)

func navigation_complete() -> void:
	state_machine.change_state("Wander")
