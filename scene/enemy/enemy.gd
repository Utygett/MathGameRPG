extends CharacterBody2D

@export var speed = 50
@export var health = 100
var target = position
var last_move_direction = Vector2.DOWN  # Сохраняем последнее направление для анимации idle

# Получаем ссылки на ноды
@onready var animated_sprite = $AnimatedSprite2D
@onready var targeted: Sprite2D = $Targeted


func _physics_process(delta):
	var move_direction = position.direction_to(target)
	velocity = move_direction * speed
	
	# Обновляем направление только при движении
	if position.distance_to(target) > 10:
		move_and_slide()
		update_animation(move_direction)
	else:
		# При остановке используем последнее направление
		play_idle_animation(last_move_direction)


func update_animation(direction: Vector2):
	# Сохраняем текущее направление для использования в idle
	last_move_direction = direction
	# Определяем доминирующее направление
	if abs(direction.x) > abs(direction.y):
		# Горизонтальное движение
		if direction.x > 0:
			animated_sprite.play("move_right")
			animated_sprite.flip_h = false  # Отражение для правой стороны
		else:
			animated_sprite.play("move_right")
			animated_sprite.flip_h = true
	else:
		# Вертикальное движение
		animated_sprite.flip_h = false
		if direction.y > 0:
			animated_sprite.play("move_down")
		else:
			animated_sprite.play("move_up")


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


func has_been_target(check:bool):
	targeted.visible = check
