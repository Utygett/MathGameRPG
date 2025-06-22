extends CharacterBody2D

@export var speed = 50
@export var max_health = 100
@export var max_energy = 100
@export var max_mathemana = 100

@onready var animated_sprite = $AnimatedSprite2D
@onready var move_component: Node = %MoveComponent
@onready var player_ui: CanvasLayer = $PlayerUI
@onready var target_system: Node2D = %TargetSystem

var current_health = 70
var current_energy = 70
var current_mathemana = 70
var last_move_direction = Vector2.DOWN  # Сохраняем последнее направление для анимации idle

enum State {ATTACK, MOVE, IDLE}
var current_state:State = State.IDLE
var player_status_bars: PlayerStatusBar
var joystick: Node2D


# Переменные отвечающие за атаку
var can_attack = true
var attack_animation_speed = 4  # Базовая скорость анимации


func _ready() -> void:
	player_status_bars = player_ui.player_status_bars
	joystick = player_ui.joystick
	InputManager.base_attack_pressed.connect(base_attack)

func _process(_delta: float) -> void:
	if current_state != State.ATTACK:
		move()

func base_attack():
	if current_state == State.ATTACK:
		return
	var target_enemy = target_system.get_current_target()
	var attack_range = 25
	if not target_enemy:
		return
	# Проверка расстояния до цели
	var distance = global_position.distance_to(target_enemy.global_position)
	# Устанавливаем скорость анимации
	animated_sprite.speed_scale = attack_animation_speed
	if distance > attack_range:
		print("Цель вне зоны досягаемости")
		current_state = State.IDLE
		return
		
	current_state = State.ATTACK
	# Вычисляем вектор направления к цели
	var direction = (target_enemy.global_position - global_position).normalized()
	# Определяем направление атаки
	if abs(direction.x) > abs(direction.y):
		# Горизонтальное направление
		if direction.x > 0:
			# Атака вправо
			animated_sprite.flip_h = false
			animated_sprite.play("attack_right")
		else:
			# Атака влево (отражение правой анимации)
			animated_sprite.flip_h = true
			animated_sprite.play("attack_right")
	else:
		# Вертикальное направление
		animated_sprite.flip_h = false  # Сбрасываем отражение
		if direction.y > 0:
			# Атака вниз
			animated_sprite.play("attack_down")
		else:
			# Атака вверх
			animated_sprite.play("attack_up")
	target_enemy.take_damage(15)
	await animated_sprite.animation_finished
	current_state = State.IDLE


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
	print("player attack")

func add_mathemana(mathemana:int):
	current_mathemana = min(max_mathemana, current_mathemana + mathemana)
	player_status_bars.set_mathemana(float(current_mathemana) / float(max_mathemana))

func move():
	var movement = movement_vector()
	var direction = movement.normalized()
	#var direction = joystick.pos_vector
	velocity = move_component.accelerate_to_direction(direction)
	#if direction:
		#velocity = direction * speed
	#else:
		#velocity = Vector2.ZERO
	move_and_slide()
		#возвращаем скорость анимации
	animated_sprite.speed_scale = 1.0
	current_state = State.MOVE
	if direction.y < -0.3:
		animated_sprite.play("move_up")
	elif direction.y > 0.3:
		animated_sprite.play("move_down")
	elif direction.x > 0.3:
			animated_sprite.play("move_right")
			animated_sprite.flip_h = false  # Отражение для правой стороны
	elif direction.x < -0.3:
			animated_sprite.play("move_right")
			animated_sprite.flip_h = true
	else:
		animated_sprite.play("idle")
		current_state = State.IDLE
