extends Control

signal num_pressed(num:String)



func _on_one_button_pressed() -> void:
	num_pressed.emit("1")


func _on_two_button_pressed() -> void:
	num_pressed.emit("2")


func _on_three_button_pressed() -> void:
	num_pressed.emit("3")


func _on_four_button_pressed() -> void:
	num_pressed.emit("4")


func _on_five_button_pressed() -> void:
	num_pressed.emit("5")


func _on_six_button_pressed() -> void:
	num_pressed.emit("6")


func _on_seven_button_pressed() -> void:
	num_pressed.emit("7")


func _on_eight_button_pressed() -> void:
	num_pressed.emit("8")


func _on_nine_button_pressed() -> void:
	num_pressed.emit("9")


func _on_add_button_pressed() -> void:
	num_pressed.emit("+")


func _on_zero_button_pressed() -> void:
	num_pressed.emit("0")

func _on_remove_button_pressed() -> void:
	num_pressed.emit("remove")


func _on_solve_button_pressed() -> void:
	num_pressed.emit("solve")
