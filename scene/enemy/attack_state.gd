class_name AttackState
extends EnemyState

var attack_cooldown: float = 1.0
var damage: int = 10

func enter() -> void:
	enemy.text_status.text = "attack"
	enemy.animation_player.play("attack")

func update(delta) -> String:
	attack_cooldown -= delta
	
	# Проверка на отступление
	if enemy.health < 20:
		return "RetreatState"
	# Проверка дистанции
	if enemy.global_position.distance_to(enemy.player.global_position) > enemy.attack_range:
		return "ChaseState"
	# Атака
	if attack_cooldown <= 0:
		enemy.player.take_damage(damage)
		attack_cooldown = 1.0
	return ""
