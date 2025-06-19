extends CanvasLayer

@onready var summ_label: Label = %SummLabel
@onready var answer_label: Label = %AnswerLabel

var m_first:int = 0
var m_second:int = 0

func _ready() -> void:
	m_first = randi_range(1,9)
	m_second = randi_range(1,9)
	summ_label.text = str(m_first) + " + " + str(m_second) + " = "

func _on_num_pad_panel_num_pressed(num: String) -> void:
	if num == "remove":
		var ans = answer_label.text
		if ans:
			answer_label.text = ans.left(-1)  # Эквивалентно my_string[:-1] в Python
	elif num == "solve":
		solve_expression()
	else:
		answer_label.text += num

func solve_expression():
	var player  = get_tree().get_first_node_in_group("player")
	var summ = m_first + m_second
	var answer = answer_label.text.to_int()
	if summ == answer:
		player.add_mathemana(5)
	queue_free()
