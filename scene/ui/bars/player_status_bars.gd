extends Control
class_name PlayerStatusBar

@onready var health_bar: ProgressBar = %HealthBar
@onready var mathemana_bar: ProgressBar = %MathemanaBar
@onready var energy_bar: ProgressBar = %EnergyBar

var m_health:float = 1
var m_mathemana:float = 1
var m_energy:float = 1

func set_health(health:float):
	health_bar.value = health

func set_mathemana(mathemana:float):
	mathemana_bar.value = mathemana

func set_energy(energy:float):
	energy_bar.value = energy
