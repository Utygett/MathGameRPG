class_name RetreatState
extends EnemyState

var safe_position: Vector2
var heal_amount: int = 5

func enter() -> void:
	enemy.text_status.text = "retreat"
	#enemy.animation_player.play("retreat")
	safe_position = find_safe_position()

func update(delta) -> String:
	
	# Проверка преследования
	if enemy.health_component.current_health > 20 && enemy.global_position.distance_to(enemy.target_plyaer.global_position) < enemy.attack_range:
		return "ChaseState"
	
	# Достигнута безопасная зона
	if enemy.global_position.distance_to(safe_position) < 10:
		enemy.health_component.current_health = min(enemy.health + heal_amount, 100)
		return "IdleState"
	
	# Движение к безопасной точке
	var direction = (safe_position - enemy.global_position).normalized()
	enemy.velocity = direction * enemy.retreat_speed
	return ""



func find_safe_position() -> Vector2:
	var safe_zones = get_tree().get_nodes_in_group("safe_zone")
	if safe_zones.is_empty():
		return Vector2(1000, 1000)  # Дефолтная позиция
	
	return safe_zones.pick_random().global_position
