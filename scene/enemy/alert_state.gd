class_name AlertState
extends EnemyState

var investigation_position: Vector2
var alert_timer: float = 5.0

func enter() -> void:
	enemy.text_status.text = "alert"
	#enemy.animation_player.play("alert")
	investigation_position = enemy.target_plyaer.global_position
	alert_timer = 5.0


func update(delta) -> String:
	alert_timer -= delta
	if can_see_player(false): # Без проверки расстояния
		return "ChaseState"
	elif alert_timer <= 0:
		return"IdleState"
	
	# Движение к точке интереса
	var direction = (investigation_position - enemy.global_position).normalized()
	enemy.velocity = direction * enemy.alert_speed
	return ""
