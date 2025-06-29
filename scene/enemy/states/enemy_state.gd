class_name EnemyState
extends Node

# Ссылка на врага и машину состояний
var enemy: CharacterBody2D
var state_machine: StateMachine

func enter() -> void:
	print("EnemyState Enter")
	pass

func exit() -> void:
	pass

func process_frame(_delta: float) -> void:
	pass

func process_physics(_delta: float) -> void:
	pass

func handle_event(_event: InputEvent) -> void:
	pass

# Общая функция проверки видимости игрока
func can_see_player(check_distance: bool = true) -> bool:
	# Проверка наличия игрока
	if not enemy.target_plyaer:
		return false
	
	# Проверка расстояния (если включена)
	if check_distance and enemy.global_position.distance_to(enemy.target_plyaer.global_position) > enemy.chase_range:
		return false
	
	# Проверка прямой видимости
	var space = enemy.get_world_2d().direct_space_state
	var params = PhysicsRayQueryParameters2D.create(
		enemy.global_position,
		enemy.target_plyaer.global_position,
		enemy.collision_mask
	)
	var result = space.intersect_ray(params)
	
	# Если луч не встретил препятствий - игрок виден
	return result.is_empty()
