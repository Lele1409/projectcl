extends CharacterBody3D

## Movement speed of player
@export var speed: float = 8  # Note: save as float since it's used to compute a float value
## Value by which the speed is multiplied when the player is running
@export var run_speed_mult: float = 1.8
## Fall acceleration, applied every physics frame (multiplied by ~1/60)
@export var fall_acceleration = 75

var target_velocity = Vector3.ZERO


func _physics_process(delta):
	# Handle character movement
	update_target_velocity(delta)
	velocity = target_velocity
	move_and_slide()


func update_target_velocity(delta) -> void:
	var movement_direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	).normalized()
	
	
	var run_speed = run_speed_mult if Input.is_action_pressed("run_hold") else 1
	# delta is 1/60 or above, so delta*60 is 1 or above (which is what we want)
	var movement_speed = speed * run_speed * (delta * 60)

	target_velocity.x = movement_direction.x * movement_speed
	target_velocity.z = movement_direction.y * movement_speed

	# apply gravity if not grounded
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
