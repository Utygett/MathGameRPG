class_name ChaseState
extends EnemyState

var last_known_position: Vector2

func enter():
	enemy.animation_player.play("run")

func update(delta) -> String:
	if not enemy.can_see_player():
		return "SearchState"
	if enemy.distance_to_player() < enemy.attack_range:
		return "AttackState"
	return ""

func physics_update(delta):
	var direction = (enemy.player.position - enemy.position).normalized()
	enemy.velocity = direction * enemy.chase_speed
	enemy.move_and_slide()
