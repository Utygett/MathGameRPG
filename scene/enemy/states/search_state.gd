class_name SearchState
extends EnemyState

var search_timer: float = 10.0
var search_positions: Array = []

func enter() -> void:
	enemy.text_status.text = "search"
	#enemy.animation_player.play("search")
	search_timer = 10.0
	generate_search_positions()

func update(delta) -> String:
	search_timer -= delta
	
	if can_see_player(false): # Без проверки расстояния
		return "ChaseState"
	elif search_timer <= 0:
		return "AlertState"
	
	# Поисковое поведение
	if enemy.global_position.distance_to(search_positions[0]) < 5:
		search_positions.pop_front()
		if search_positions.is_empty():
			generate_search_positions()
	
	var direction = (search_positions[0] - enemy.global_position).normalized()
	enemy.velocity = direction * enemy.search_speed
	return ""

func generate_search_positions() -> void:
	for i in range(5):
		var angle = randf_range(0, TAU)
		var distance = randf_range(20, 100)
		search_positions.append(enemy.global_position + Vector2.RIGHT.rotated(angle) * distance)
