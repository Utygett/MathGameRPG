extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent

@export var speed = 50
var target_plyaer:Node2D = null
var target = position
var last_move_direction = Vector2.DOWN  # Сохраняем последнее направление для анимации idle

# Получаем ссылки на ноды
@onready var animated_sprite = $AnimatedSprite2D
@onready var targeted: Sprite2D = $Targeted
@onready var player_detection: Node2D = $PlayerDetection

func _ready() -> void:
	player_detection.player_detected.connect(player_detected_func)
	player_detection.player_lost.connect(player_lost_func)
	health_component.died.connect(on_died)

func _physics_process(delta):
	if target_plyaer:
		var move_direction = position.direction_to(target_plyaer.global_position)
		velocity = move_direction * speed
		# Обновляем направление только при движении
		if position.distance_to(target) > 10:
			move_and_slide()
			update_animation(move_direction)
		else:
			# При остановке используем последнее направление
			play_idle_animation(last_move_direction)


func player_detected_func(player:Node2D):
	target_plyaer = player

func player_lost_func():
	target_plyaer = null



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

func take_damage(damage:int):
	health_component.take_damage(damage)

func on_died():
	#var back_layer = get_tree().get_first_node_in_group("back_layer")
	#var death_instance = death_scene.instantiate() as DeathComp
	#back_layer.add_child(death_instance)
	#death_instance.gpu_particles_2d.texture = sprite
	#death_instance.sprite_offest.position.y = animated_sprite_2d.offset.y
	#death_instance.global_position = global_position
	queue_free()
