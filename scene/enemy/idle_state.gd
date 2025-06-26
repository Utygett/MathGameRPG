class_name IdleState
extends EnemyState

var patrol_path: Path2D
var patrol_points: Array
var current_patrol_index: int = 0

func enter() -> void:
	enemy.animated_sprite.play("idle")
	patrol_path = enemy.get_node("PatrolPath")
	patrol_points = patrol_path.curve.get_baked_points()

func process_frame(delta: float) -> void:
	# Проверка обнаружения игрока
	if can_see_player(true): # С проверкой расстояния
		state_machine.change_state(state_machine.get_node("AlertState"))
	
	# Патрулирование
	patrol(delta)


func patrol(delta: float) -> void:
	if patrol_points.is_empty():
		return
	
	var target = patrol_points[current_patrol_index]
	if enemy.global_position.distance_to(target) < 5:
		current_patrol_index = (current_patrol_index + 1) % patrol_points.size()
		target = patrol_points[current_patrol_index]
	
	var direction = (target - enemy.global_position).normalized()
	enemy.velocity = direction * enemy.patrol_speed
