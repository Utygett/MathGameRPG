class_name StateMachine
extends Node

var current_state: EnemyState
var states: Dictionary = {}

func init(enemy: CharacterBody2D) -> void:
	# Автоматически собираем все состояния
	for child in get_children():
		if child is EnemyState:
			child.enemy = enemy
			states[child.name] = child
			child.state_machine = self
	change_state("IdleState")

func _process(delta):
	var next_state = current_state.update(delta)
	if next_state:
		change_state(next_state)

func change_state(new_state_name: String):
	if current_state:
		current_state.exit()
	current_state = states.get(new_state_name)
	current_state.enter()

func handle_event(event: InputEvent) -> void:
	current_state.handle_event(event)
