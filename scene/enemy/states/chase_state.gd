class_name ChaseState
extends EnemyState

var last_known_position: Vector2

func enter():
	enemy.text_status.text = "chase"
	#enemy.animation_player.play("run")

func update(delta) -> String:
	if not can_see_player():
		return "SearchState"
	if enemy.global_position.distance_to(enemy.target_plyaer.global_position) < enemy.attack_range:
		return "AttackState"
	return ""

func physics_update(delta):
	var direction = (enemy.player.position - enemy.position).normalized()
	enemy.velocity = direction * enemy.chase_speed
	enemy.move_and_slide()
