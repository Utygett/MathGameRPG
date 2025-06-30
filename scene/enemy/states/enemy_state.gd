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
	# 1. Проверка наличия игрока
	if not enemy.target_plyaer:  # Исправлено: target_plyaer -> target_player
		print("Игрок не назначен как цель")
		return false
	
	# 2. Проверка расстояния
	var distance = enemy.global_position.distance_to(enemy.target_plyaer.global_position)
	if check_distance and distance > enemy.chase_range:
		print("Игрок вне радиуса обнаружения: ", distance, " > ", enemy.chase_range)
		return false
	
	# 3. Проверка прямой видимости
	var space = enemy.get_world_2d().direct_space_state
	var params = PhysicsRayQueryParameters2D.create(
		enemy.global_position,
		enemy.target_plyaer.global_position,
		enemy.collision_mask,
		[enemy.target_plyaer]  # Игнорируем коллизии самого врага
	)
	var result = space.intersect_ray(params)
	
	# Дебаг-рисование луча (видно только в редакторе)
	#DebugDraw2D.draw_line_3d(enemy.global_position, enemy.target_player.global_position, Color.RED, 0.1)
	
	if result:
		print("Препятствие между врагом и игроком: ", result.collider.name)
		return false
	
	print("Игрок виден! Дистанция: ", distance)
	return true
