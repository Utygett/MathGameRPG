class_name Enemy
extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent


@export_category("State Machine")
@export var initial_state: EnemyState

@export_category("Combat Settings")
@export var attack_range: float = 20.0
@export var chase_range: float = 150.0
@export var health: int = 100
@export var speed = 40
@export var patrol_speed = 20
@export var alert_speed = 25
@export var retreat_speed = 35
@export var search_speed = 25

var target_plyaer:Node2D = null
var target = position
var last_move_direction = Vector2.DOWN  # Сохраняем последнее направление для анимации idle

# Получаем ссылки на ноды
@onready var animated_sprite = $AnimatedSprite2D
@onready var targeted: Sprite2D = $Targeted
@onready var player_detection: Node2D = $PlayerDetection
@onready var state_machine: StateMachine = $StateMachine
@onready var text_status: Label = $TextStatus

func _ready() -> void:
	player_detection.player_detected.connect(player_detected_func)
	player_detection.player_lost.connect(player_lost_func)
	health_component.died.connect(on_died)
	
	state_machine.init(self)

func _process(delta: float) -> void:
	#state_machine.process(delta)
	pass

func _physics_process(delta):
	if target_plyaer && health_component.current_health > 20:
		var move_direction = position.direction_to(target_plyaer.global_position)
		velocity = move_direction * speed
		# Обновляем направление только при движении
		if position.distance_to(target_plyaer.global_position) > 15:
			move_and_slide()
			update_animation(move_direction)
		else:
			# При остановке используем последнее направление
			play_idle_animation(last_move_direction)
	else :
		move_and_slide()


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
