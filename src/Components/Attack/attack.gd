extends Node
class_name AttackNode

## Node the attack originates from
@export var attacker: Node
## Amount of damage (on avg) the attack should do
@export var damage: float = 5
## Maximum possible variance to damage. If 0, the damage will always be the same
@export var damage_variance: float = 0.5
## Knockback the attack is supposed to inflict on target
@export var knockback: float


# --------- Getters and Setters --------- :
func get_attacker() -> Node:
	return attacker


func get_damage() -> float:
	return damage + (randf_range(-damage_variance, damage_variance))


func get_knockback() -> float:
	return knockback
