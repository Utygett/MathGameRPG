class_name IdleState
extends EnemyState

var patrol_points: Array[Vector2] = []
var current_patrol_index: int = 0
var base_position: Vector2  # Запомним начальную позицию

func enter() -> void:
	enemy.text_status.text = "idle"
	#enemy.animated_sprite.play("idle")
	generate_random_patrol(4, 100.0)

func update(delta) -> String:
	# Проверка обнаружения игрока
	if can_see_player(true): # С проверкой расстояния
		return "AlertState"
	# Патрулирование
	patrol(delta)
	return ""


func patrol(delta: float) -> void:
	if patrol_points.is_empty():
		return
	
	var target = patrol_points[current_patrol_index]
	if enemy.global_position.distance_to(target) < 5:
		current_patrol_index = (current_patrol_index + 1) % patrol_points.size()
		target = patrol_points[current_patrol_index]
	
	var direction = (target - enemy.global_position).normalized()
	enemy.velocity = direction * enemy.patrol_speed

func generate_random_patrol(point_count: int, radius: float) -> void:
	for i in range(point_count):
		var angle = TAU * i / point_count
		var offset = Vector2(cos(angle), sin(angle)) * radius * randf_range(0.8, 1.2)
		patrol_points.append(base_position + offset)
