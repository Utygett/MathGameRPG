extends Node2D

# 			Система выбора противника
# Система находит всех противников в радиусе и позволяет выбирать цель
# Есть 2 режима "ближайшаяя цель" или выбор цели в ручном режиме
# - Режим "ближайшей цели" выдаёт ближайшую цель в радиусе
# - Ручной режим выбора цели позвоялет переключаться с помощью сигнала
# к следующей по расстоянию цели.
# При сбросе ручного режима выдаётбся ближайшая к игроку цель.

@onready var enemy_detecion_area: Area2D = $EnemyDetecionArea
var current_target: Node2D = null
var is_manual_target: bool = false

func _process(delta: float) -> void:
	if is_manual_target == false:
		set_target(enemy_detecion_area.get_nearest_enemy())

func _ready() -> void:
	InputManager.target_switch_pressed.connect(switch_target)
	InputManager.target_clear_pressed.connect(clear_target)

func set_target(new_target: Node2D):
	if current_target && is_instance_valid(current_target):
			current_target.has_been_target(false)
	if new_target and enemy_detecion_area.detected_enemies.has(new_target):
		current_target = new_target
		current_target.has_been_target(true)
		return true
	return false

# Публичный интерфейс для игрока
func get_current_target() -> Node2D:
	if current_target == null:
		clear_target()
	return current_target

# Обработка ввода
func switch_target():
	if enemy_detecion_area.detected_enemies.size() < 2:
		return
	
	var current_index = enemy_detecion_area.detected_enemies.find(current_target)
	var next_index = (current_index + 1) % enemy_detecion_area.detected_enemies.size()
	
	is_manual_target = true
	set_target(enemy_detecion_area.detected_enemies[next_index])

func clear_target():
	is_manual_target = false
	if current_target && is_instance_valid(current_target):
		current_target.has_been_target(false)
	current_target = null
	# Автовыбор новой цели
	set_target(enemy_detecion_area.get_nearest_enemy())
