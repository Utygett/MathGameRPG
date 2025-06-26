class_name RetreatState
extends EnemyState

var safe_position: Vector2
var heal_amount: int = 5

func enter() -> void:
	enemy.animation_player.play("retreat")
	safe_position = find_safe_position()

func process_frame(delta: float) -> void:
	# Проверка преследования
	if enemy.global_position.distance_to(enemy.player.global_position) < enemy.attack_range:
		state_machine.change_state(state_machine.get_node("ChaseState"))
	
	# Достигнута безопасная зона
	if enemy.global_position.distance_to(safe_position) < 10:
		enemy.health = min(enemy.health + heal_amount, 100)
		state_machine.change_state(state_machine.get_node("IdleState"))
	
	# Движение к безопасной точке
	var direction = (safe_position - enemy.global_position).normalized()
	enemy.velocity = direction * enemy.retreat_speed

func find_safe_position() -> Vector2:
	var safe_zones = get_tree().get_nodes_in_group("safe_zone")
	if safe_zones.is_empty():
		return Vector2(1000, 1000)  # Дефолтная позиция
	
	return safe_zones.pick_random().global_position
