extends CharacterBody3D
class_name AIController

@export var walk_speed: float = 1.0
@export var run_speed: float = 2.5

var is_running: bool = false
var is_stopped: bool = false

var move_direction: Vector3
var target_y_rotation: float

var look_at_player: bool = false
var player_distance: float

@onready var agent: NavigationAgent3D = %NavigationAgent
@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var player: PlayerController = get_tree().get_first_node_in_group("Player")

func _process(_delta: float) -> void:
	if player:
		player_distance = position.distance_to(player.position)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	var target_position = agent.get_next_path_position()
	var move_direction = position.direction_to(target_position)
	move_direction.y = 0 # move flat on the ground
	move_direction = move_direction.normalized()

	if agent.is_navigation_finished() or is_stopped:
		move_direction = Vector3.ZERO

	var current_speed = walk_speed

	if is_running:
		current_speed = run_speed

	velocity.x = move_direction.x * current_speed
	velocity.z = move_direction.z * current_speed

	move_and_slide()

	if look_at_player:
		var player_direction = player.position - position
		target_y_rotation = atan2(player_direction.x, player_direction.z)
	elif velocity.length() > 0:
		target_y_rotation = atan2(velocity.x, velocity.z)

	rotation.y = lerp_angle(rotation.y, target_y_rotation, 0.1)

func move_to_position(to_position: Vector3, adjust_position: bool = true):
	if not agent:
		agent = %NavigationAgent

	is_stopped = false

	# potentially expensive operation
	if adjust_position:
		var map = get_world_3d().navigation_map
		var adjusted_position = NavigationServer3D.map_get_closest_point(map, to_position)
		agent.target_position = adjusted_position
	# player should already be on nav mesh, so we can skip the adjustment
	else:
		agent.target_position = to_position
