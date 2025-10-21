extends RigidBody2D

class_name Thermal_body

#signals
signal apply_impulse(vec)

#onready
@onready var CollisionShape = $CollisionShape2D

#const

#vars
var temperature: float = 2.7  # Start at cosmic background temp (Kelvin)
var specific_heat: float = 1000.0
var emissivity: float = 0.9  # 0-1, how well it emits radiation
var albedo: float = 0.3 # 0-1, how much light it reflects
var density: float

func _ready() -> void:
	$Sprite2D.scale = Vector2.ONE*mass
	$CollisionShape2D.scale = Vector2.ONE*mass

func _process(delta: float) -> void:
	pass


func _on_apply_impulse(vec: Vector2) -> void:
	apply_central_impulse(vec)

func update_visual():
	if temperature < 100:
		$Sprite2D.modulate = Color.DARK_BLUE
	elif temperature < 200:
		$Sprite2D.modulate = Color.BLUE
	elif temperature < 273:
		$Sprite2D.modulate = Color.CYAN
	elif temperature < 300:
		$Sprite2D.modulate = Color.GREEN
	elif temperature < 500:
		$Sprite2D.modulate = Color.YELLOW
	elif temperature < 1000:
		$Sprite2D.modulate = Color.ORANGE
	else:
		$Sprite2D.modulate = Color.RED
