extends Node
class_name HealthComponent

signal died
signal health_change(current_health:float, max_health:float)

@export var max_health:float = 10
@export var damage_text_scene:PackedScene

# Добавляем настройки цветов
@export var player_damage_color: Color = Color.YELLOW
@export var enemy_damage_color: Color = Color.RED
@export var neutral_damage_color: Color = Color.WHITE

var current_health:float

func _ready() -> void:
	current_health = max_health

func take_damage(damage, source = null):
	var front_layer = get_tree().get_first_node_in_group("front_layer") as Node2D
	var damage_text_instance = damage_text_scene.instantiate() as Node2D
	front_layer.add_child(damage_text_instance)
	damage_text_instance.global_position = owner.global_position
	# Определяем цвет в зависимости от источника урона
	var text_color = determine_damage_color(source)
	damage_text_instance.damage_text(damage, text_color)
	current_health = max(current_health - damage, 0)
	health_change.emit(current_health, max_health)
	Callable(check_death).call_deferred()

func get_health_value():
	return current_health / max_health

func check_death():
	if current_health == 0:
		died.emit()

# Функция для определения цвета урона
func determine_damage_color(source) -> Color:
	if source == null:
		return neutral_damage_color
	
	# Если источник урона - игрок
	if source.is_in_group("player"):
		return player_damage_color
	
	# Если источник урона - враг
	if source.is_in_group("enemies"):
		return enemy_damage_color
	
	return neutral_damage_color
