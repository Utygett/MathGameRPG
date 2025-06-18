extends CharacterBody2D

@export var speed = 50
@export var max_health = 100
@export var max_energy = 100
@export var max_mathemana = 100
var current_health = 70
var current_energy = 70
var current_mathemana = 70
var last_move_direction = Vector2.DOWN  # Сохраняем последнее направление для анимации idle
var is_attacking = false # Флаг для отслеживания состояния атаки
# Получаем ссылки на ноды
@onready var animated_sprite = $AnimatedSprite2D
@onready var move_component: Node = %MoveComponent
@onready var joystick: Node2D = $Joystick



func _process(_delta: float) -> void:
	if is_attacking:
		return  # Пропускаем движение во время атаки
		
	var movement = movement_vector()
	#var direction = movement.normalized()
	var direction = joystick.pos_vector
	velocity = move_component.accelerate_to_direction(direction)
	#if direction:
		#velocity = direction * speed
	#else:
		#velocity = Vector2.ZERO
	move_and_slide()
	if direction.y < -0.5:
		animated_sprite.play("move_up")
	elif direction.y > 0.5:
		animated_sprite.play("move_down")
	elif direction.x > 0.5:
			animated_sprite.play("move_right")
			animated_sprite.flip_h = false  # Отражение для правой стороны
	elif direction.x < -0.5:
			animated_sprite.play("move_right")
			animated_sprite.flip_h = true
	else:
		animated_sprite.play("idle")


func movement_vector():
	var movement_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var movement_y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(movement_x, movement_y)

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
