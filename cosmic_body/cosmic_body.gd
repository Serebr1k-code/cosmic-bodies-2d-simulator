extends RigidBody2D

class_name Thermal_body

#signals
signal apply_impulse(vec)

#onready

#const

#vars
var temperature: float = 2.7  # Start at cosmic background temp (Kelvin)
var specific_heat: float = 1000.0
var emissivity: float = 0.9  # 0-1, how well it emits radiation
var albedo: float = 0.3 # 0-1, how much light it reflects
#only for planets:
var atmosphere_thickness: float = 1.0  # 0-1, affects greenhouse effect
var rotation_speed: float = 1.0
var current_angle: float = 0.0

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _on_apply_impulse(vec: Vector2) -> void:
	apply_central_impulse(vec)

func update_visual():
	pass
	#if temperature < 100:
		#color = Color.DARK_BLUE
	#elif temperature < 200:
		#color = Color.BLUE
	#elif temperature < 273:
		#color = Color.CYAN
	#elif temperature < 300:
		#color = Color.GREEN
	#elif temperature < 500:
		#color = Color.YELLOW
	#elif temperature < 1000:
		#color = Color.ORANGE
	#else:
		#color = Color.RED
