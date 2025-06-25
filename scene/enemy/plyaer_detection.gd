extends Node2D

@onready var player_detecion_area: Area2D = $PlayerDetecionArea

signal player_detected(plyaer:Node2D)
signal player_lost()


func _ready() -> void:
	player_detecion_area.player_detected.connect(player_detected_func)
	player_detecion_area.player_lost.connect(player_lost_func)

func player_detected_func(player:Node2D):
	player_detected.emit(player)

func player_lost_func():
	player_lost.emit()
