extends CharacterBody2D

@export var speed = 50
@export var max_health = 100
@export var max_energy = 100
@export var max_mathemana = 100

@onready var animated_sprite = $AnimatedSprite2D
@onready var move_component: Node = %MoveComponent
@onready var player_ui: CanvasLayer = $PlayerUI

var current_health = 70
var current_energy = 70
var current_mathemana = 70
var last_move_direction = Vector2.DOWN  # Сохраняем последнее направление для анимации idle


var player_status_bars: PlayerStatusBar
var joystick: Node2D

func _ready() -> void:
	player_status_bars = player_ui.player_status_bars
	joystick = player_ui.joystick

func _process(_delta: float) -> void:
	var movement = movement_vector()
	var direction = movement.normalized()
	#var direction = joystick.pos_vector
	velocity = move_component.accelerate_to_direction(direction)
	#if direction:
		#velocity = direction * speed
	#else:
		#velocity = Vector2.ZERO
	move_and_slide()
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
