class_name StateMachine
extends Node

@export var initial_state: EnemyState
var current_state: EnemyState

func init(enemy: CharacterBody2D) -> void:
	for child in get_children():
		child.enemy = enemy
		child.state_machine = self
	
	current_state = initial_state
	current_state.enter()

func change_state(new_state: EnemyState) -> void:
	current_state.exit()
	current_state = new_state
	current_state.enter()

func process_frame(delta: float) -> void:
	current_state.process_frame(delta)

func process_physics(delta: float) -> void:
	current_state.process_physics(delta)

func handle_event(event: InputEvent) -> void:
	current_state.handle_event(event)
