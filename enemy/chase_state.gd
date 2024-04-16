extends State

@export var flee_range: float = 1.0
@export var lose_interest_range: float = 10.0

var path_update_interval: float = 0.1
var last_path_update_time: float

func enter() -> void:
	super.enter()
	controller.is_running = true
	controller.look_at_player = true

func exit() -> void:
	super.exit()
	controller.is_running = false
	controller.look_at_player = false

func update(delta: float) -> void:
	var current_time = Time.get_unix_time_from_system()

	if (current_time - last_path_update_time) > path_update_interval:
		last_path_update_time = current_time
		controller.move_to_position(controller.player.position, false)

	if controller.player_distance < flee_range:
		state_machine.change_state("Flee")

	if controller.player_distance > lose_interest_range:
		state_machine.change_state("Wander")
