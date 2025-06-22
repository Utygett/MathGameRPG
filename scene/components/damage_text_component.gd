extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Label


func damage_text(damage: float, text_color: Color = Color.WHITE):
	var format_text = "%0.1f"
	if damage == round(damage):
		format_text = "%0.0f"
	
	label.text = format_text % damage
	label.modulate = text_color  # Устанавливаем цвет текста
	animation_player.play("damage_text")
