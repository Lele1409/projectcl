extends CharacterBody3D

## Movement speed of player
@export var speed = 8
## Fall acceleration, applied every physics frame (multiplied by ~1/60)
@export var fall_acceleration = 75

var target_velocity = Vector3.ZERO


func _physics_process(delta):
	print(delta)
	
	# Handle character movement
	update_target_velocity(delta)
	velocity = target_velocity
	move_and_slide()


func update_target_velocity(delta) -> void:
	var movement_direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	).normalized()
	
	var movement_adjust = speed * (delta * 60)  # delta should be around 1/60, so delta*60 should be 1

	target_velocity.x = movement_direction.x * movement_adjust
	target_velocity.z = movement_direction.y * movement_adjust

	# apply gravity if not grounded
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
