extends Sprite2D

@onready var joystick: Node2D = $".."

@export var max_lenght = 50
@export var deadzone = 5

var m_pressing = false



func _process(delta: float) -> void:
	if m_pressing:
		if get_global_mouse_position().distance_to(joystick.global_position) <=max_lenght:
			global_position = get_global_mouse_position()
		else:
			var angle = joystick.global_position.angle_to_point(get_global_mouse_position())
			global_position.x = joystick.global_position.x + cos(angle) * max_lenght
			global_position.y = joystick.global_position.y + sin(angle) * max_lenght
		calculate_vector()
	else:
		global_position = lerp(global_position, joystick.global_position, delta*30)
		joystick.pos_vector = Vector2.ZERO

func calculate_vector():
	if abs((global_position.x - joystick.global_position.x)) >= deadzone:
		joystick.pos_vector.x = (global_position.x - joystick.global_position.x) / max_lenght
	if abs((global_position.y - joystick.global_position.y)) >= deadzone:
		joystick.pos_vector.y = (global_position.y - joystick.global_position.y) / max_lenght
func _on_button_button_down() -> void:
	m_pressing = true


func _on_button_button_up() -> void:
	m_pressing = false
