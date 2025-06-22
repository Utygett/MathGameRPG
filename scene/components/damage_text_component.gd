extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Label


func damage_text(damage):
	var format_text = "%0.1f"
	if damage == round(damage):
		format_text = "%0.0f"
	label.text = format_text % damage
	animation_player.play("damage_text")
