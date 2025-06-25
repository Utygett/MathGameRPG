extends Area2D

var detected_player: Array = []
var nearest_enemy: Node2D = null
signal player_detected(plyaer:Node2D)
signal player_lost()

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D):
	if body.is_in_group("player") and !detected_player.has(body):
		print("player entered")
		player_detected.emit(body)
		detected_player.append(body)

func _on_body_exited(body: Node2D):
	if detected_player.has(body):
		detected_player.erase(body)
		player_lost.emit()

func get_nearest_player() -> Node2D:
	if detected_player.is_empty():
		return null
	
	var nearest: Node2D = detected_player[0]
	var min_distance = global_position.distance_to(nearest.global_position)
	
	for player in detected_player:
		if is_instance_valid(player):  # Проверка на удаленный объект
			var dist = global_position.distance_to(player.global_position)
			if dist < min_distance:
				min_distance = dist
				nearest = player
	
	return nearest
