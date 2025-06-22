extends ProgressBar

@onready var health_component: HealthComponent = %HealthComponent

func _ready() -> void:
	health_component.connect("health_change", health_change)
	value = 1.0

func health_change(current_health, max_health):
	value = current_health / max_health
