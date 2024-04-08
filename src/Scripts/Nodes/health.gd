extends Node
class_name HealthNode

signal on_damaged
signal on_regenerate

enum RegenState {
	## Entity can regenerate and does
	active,
	## Entity can regenerate, but (temporarily) doesn't
	halted,
	## Entity can't regenerate
	stopped,
}

## Maximum amount of health the entity has by default
@export var max_health: float = 20
## Specify whether regeneration should be enabled or not
@export var regen_state: RegenState = RegenState.active
## Amount of health the entity regenerates every second (float)
@export var regen_per_second: float = 0.1
## Timer used to manage entity regeneration
@export var timer: Timer
var current_health: float = 20
var halt_regen_time: int = 5  # Add default value in case someone sets RegenState to halted


func _ready():
	current_health = 10
	
	if regen_state != RegenState.stopped:
		timer.start(1)  # only use timer if regen is active
		timer.timeout.connect(_on_timer_timeout)


func _on_timer_timeout():
	if regen_state == RegenState.active:
		regenerate()  # regen if active
	
	elif regen_state == RegenState.halted:
		if halt_regen_time <= 0:  # check if leq in case a call is skipped
			regen_state = RegenState.active
		halt_regen_time -= 1
	
	timer.start(1)  # restart timer (loop every second)


func regenerate() -> void:
	if current_health == max_health:
		return  # skip unnecessary operations
	
	# make sure regen doesn't lead to exceeding of max_health
	current_health = clamp(
		0,
		current_health + regen_per_second,
		max_health
	)
	
	on_regenerate.emit()


func halt_regen(time: int) -> void:
	# Only halt regen if it is active (don't do anything otherwise) 
	if regen_state == RegenState.active:
		halt_regen_time = time
		regen_state = RegenState.halted


# ---------------- Utility functions ---------------- :
func damage(attack: AttackNode) -> void:
	var health_after_damage: float = clamp(
		0,  # health can't be negative
		current_health - attack.get_damage(),  # health after applying damage
		max_health  # health can't exceed max_health
	)  # get new value of health after damage is applied
	
	if health_after_damage < current_health: 
		on_damaged.emit()  # only emit signal if actually lost health
	
	current_health = health_after_damage  # update current health
	halt_regen(5)  # wait 5 secs before restarting regen


func heal(amount: float) -> void:
	current_health += amount


# ------ Getters and Setters  ------ :
func get_current() -> float:
	return current_health


func get_max() -> float:
	return max_health


func set_current(amount: float) -> void:
	# This function shouldn't be called (use damage() or heal() instead)
	current_health = amount


func set_max(amount: float) -> void:
	if amount > 0:
		max_health = amount
