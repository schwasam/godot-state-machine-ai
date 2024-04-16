extends State

@export var max_wander_range: float = 10.0
@export var min_wait_time: float = 0.2
@export var max_wait_time: float = 5.0

var home_position: Vector3

func enter() -> void:
	super.enter()
	home_position = controller.position
	_wander_to_new_position()

func navigation_complete() -> void:
	var wait_time = randf_range(min_wait_time, max_wait_time)
	await get_tree().create_timer(wait_time).timeout

	# abort if state has changed during timer
	if not active:
		return

	_wander_to_new_position()

func _wander_to_new_position() -> void:
	var position = home_position + random_offset() * randf_range(0, max_wander_range)
	controller.move_to_position(position)
