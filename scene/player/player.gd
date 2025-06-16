extends CharacterBody2D

@export var speed = 50
var last_move_direction = Vector2.DOWN  # Сохраняем последнее направление для анимации idle
var is_attacking = false # Флаг для отслеживания состояния атаки
# Получаем ссылки на ноды
@onready var animated_sprite = $AnimatedSprite2D
@onready var move_component: Node = %MoveComponent


func _process(_delta: float) -> void:
	if is_attacking:
		return  # Пропускаем движение во время атаки
		
	var movement = movement_vector()
	var direction = movement.normalized()
	
	velocity = move_component.accelerate_to_direction(direction)
	move_and_slide()
	if direction.y < -0.5:
		animated_sprite.play("move_up")
	elif direction.y > 0.5:
		animated_sprite.play("move_down")
	elif direction.x > 0.5:
		animated_sprite.play("move_right")
	elif direction.x < -0.5:
		animated_sprite.play("move_left")
	else:
		animated_sprite.play("idle")

func movement_vector():
	var movement_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var movement_y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(movement_x, movement_y)

#func _physics_process(delta):
	#if is_attacking:
		#return  # Пропускаем движение во время атаки
	#var move_direction = position.direction_to(target)
	#velocity = move_direction * speed
	## Обновляем направление только при движении
	#if position.distance_to(target) > 10:
		#move_and_slide()
		#update_animation(move_direction)
	#else:
		## При остановке используем последнее направление
		#play_idle_animation(last_move_direction)
#
#func update_animation(direction: Vector2):
	## Сохраняем текущее направление для использования в idle
	#last_move_direction = direction
	#
	## Определяем доминирующее направление
	#if abs(direction.x) > abs(direction.y):
		## Горизонтальное движение
		#if direction.x > 0:
			#animated_sprite.play("move_right")
			#animated_sprite.flip_h = false  # Отражение для правой стороны
		#else:
			#animated_sprite.play("move_right")
			#animated_sprite.flip_h = true
	#else:
		## Вертикальное движение
		#animated_sprite.flip_h = false
		#if direction.y > 0:
			#animated_sprite.play("move_down")
		#else:
			#animated_sprite.play("move_up")

func play_idle_animation(last_direction: Vector2):
	# Всегда сбрасываем отражение в idle
	animated_sprite.flip_h = false
	
	# Выбираем анимацию idle на основе последнего направления
	if abs(last_direction.x) > abs(last_direction.y):
		animated_sprite.play("idle")
	else:
		if last_direction.y > 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("idle_up")

# Умение атаки
func attack_skill():
	if is_attacking:
		return
		
	print("player attack")
	is_attacking = true
	
	# Выбираем анимацию атаки по последнему направлению
	if abs(last_move_direction.x) > abs(last_move_direction.y):
		if last_move_direction.x > 0:
			animated_sprite.play("attack_right")
		else:
			animated_sprite.play("attack_left")
	else:
		if last_move_direction.y > 0:
			animated_sprite.play("attack_down")
		else:
			animated_sprite.play("attack_up")
	
	# Ждем завершения анимации
	await animated_sprite.animation_finished
	is_attacking = false
	play_idle_animation(last_move_direction)  # Возвращаемся в idle
