class_name AlertState
extends EnemyState

var investigation_position: Vector2
var alert_timer: float = 5.0

func enter() -> void:
	enemy.animation_player.play("alert")
	investigation_position = enemy.player.last_known_position
	alert_timer = 5.0

func process_frame(delta: float) -> void:
	alert_timer -= delta
	
	if can_see_player(false): # Без проверки расстояния
		state_machine.change_state(state_machine.get_node("ChaseState"))
	elif alert_timer <= 0:
		state_machine.change_state(state_machine.get_node("IdleState"))
	
	# Движение к точке интереса
	var direction = (investigation_position - enemy.global_position).normalized()
	enemy.velocity = direction * enemy.alert_speed
