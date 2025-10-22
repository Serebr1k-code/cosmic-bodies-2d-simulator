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
var density: float = 1/1000

#func _ready() -> void:
	#$Sprite2D.scale = Vector2.ONE*mass*density
	#$CollisionShape2D.scale = Vector2.ONE*mass*density

func _process(delta: float) -> void:
	pass


func _on_apply_impulse(vec: Vector2) -> void:
	apply_central_impulse(vec)

func update_visual():
	$Sprite2D.modulate = Color(min(temperature/1000, 1.0), min(temperature/2000, 0.5), max(1-temperature/1000, 0.0))
