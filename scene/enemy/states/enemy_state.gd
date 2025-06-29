class_name EnemyState
extends Node

signal state_completed(next_state_name)

var state_machine: StateMachine
var enemy: Enemy

func enter(): pass
func exit(): pass
func update(delta: float) -> String: return ""  # Возвращает имя следующего состояния
func physics_update(delta: float): pass

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
