class_name AttackState
extends EnemyState

var attack_cooldown: float = 1.0
var damage: int = 10

func enter() -> void:
	enemy.animation_player.play("attack")

func process_frame(delta: float) -> void:
	attack_cooldown -= delta
	
	# Проверка на отступление
	if enemy.health < 20:
		state_machine.change_state(state_machine.get_node("RetreatState"))
	
	# Проверка дистанции
	if enemy.global_position.distance_to(enemy.player.global_position) > enemy.attack_range:
		state_machine.change_state(state_machine.get_node("ChaseState"))
	
	# Атака
	if attack_cooldown <= 0:
		enemy.player.take_damage(damage)
		attack_cooldown = 1.0
