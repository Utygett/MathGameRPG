extends CanvasLayer

@onready var summ_label: Label = %SummLabel
@onready var answer_line_edit: LineEdit = %AnswerLineEdit

var m_ansver = 10

func _on_answer_line_edit_text_changed(new_text: String) -> void:
	print(new_text)
	if new_text.to_int() == 10:
		var player  = get_tree().get_first_node_in_group("player")
		if player != null:
			player.attack_skill()
			queue_free()


func _on_cancel_button_pressed() -> void:
	queue_free()
