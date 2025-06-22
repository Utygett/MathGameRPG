extends CanvasLayer

var ability_add_scnee = preload("res://scene/ui/abilities/add/ability_add.tscn")

func _on_1ability_slot_pressed() -> void:
	print("one")
	#Получить доступ к типу умению который пользователь выставил, и воспроизвести сцену умения
	get_parent().add_child(ability_add_scnee.instantiate())


func _on_2ability_slot_pressed() -> void:
	InputManager.base_attack_pressed.emit()
	print("two")


func _on_3ability_slot_pressed() -> void:
	print("three")


func _on_4ability_slot_pressed() -> void:
	print("four")
