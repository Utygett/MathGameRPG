extends Area2D

var detected_enemies: Array = []
var nearest_enemy: Node2D = null

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D):
	if body.is_in_group("enemies") and !detected_enemies.has(body):
		detected_enemies.append(body)

func _on_body_exited(body: Node2D):
	if detected_enemies.has(body):
		detected_enemies.erase(body)

func get_nearest_enemy() -> Node2D:
	if detected_enemies.is_empty():
		return null
	
	var nearest: Node2D = detected_enemies[0]
	var min_distance = global_position.distance_to(nearest.global_position)
	
	for enemy in detected_enemies:
		if is_instance_valid(enemy):  # Проверка на удаленный объект
			var dist = global_position.distance_to(enemy.global_position)
			if dist < min_distance:
				min_distance = dist
				nearest = enemy
	
	return nearest
