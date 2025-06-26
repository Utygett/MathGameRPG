class_name ChaseState
extends EnemyState

var last_known_position: Vector2

func enter() -> void:
	enemy.animation_player.play("chase")

func process_frame(delta: float) -> void:
	if can_see_player(false): # Без проверки расстояния
		last_known_position = enemy.player.global_position
		enemy.velocity = (last_known_position - enemy.global_position).normalized() * enemy.chase_speed
		
		if enemy.global_position.distance_to(enemy.player.global_position) < enemy.attack_range:
			state_machine.change_state(state_machine.get_node("AttackState"))
	else:
		state_machine.change_state(state_machine.get_node("SearchState"))
