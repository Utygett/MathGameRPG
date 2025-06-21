extends Node

# Сигналы для системы целей
signal target_switch_pressed
signal target_clear_pressed

func _input(event):
	if event.is_action_pressed("switch_target"):
		target_switch_pressed.emit()
	
	if event.is_action_pressed("clear_target"):
		target_clear_pressed.emit()
