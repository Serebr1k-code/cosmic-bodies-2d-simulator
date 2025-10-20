extends Node2D

#signals

#onready
@onready var cosmic_body = preload("res://cosmic_body/cosmic body.tscn")
var G = 667

#const
const STEFAN_BOLTZMANN: float = 5.67e-8

#vars
var thermal_bodies: Array[Thermal_body] = []

func _ready() -> void:
	var balls = []
	for i in range(10):
		balls.append(cosmic_body.instantiate())
		balls[i].position = Vector2(randi_range(100, 1200), randi_range(100, 600))
		balls[i].mass = randf()
		add_child(balls[i])

func _process(delta: float) -> void:
	handle_gravity(delta)
	handle_temperature(delta)

func handle_gravity(delta):
	for child in get_children():
		for secondfuckingchild in get_children():
			if child.is_in_group("physics") and secondfuckingchild.is_in_group("physics"):
				var dist = child.position.distance_to(secondfuckingchild.position)
				if dist != 0 and !are_bodies_touching(child, secondfuckingchild):
					var power = child.mass*secondfuckingchild.mass/(dist**2)*G
					child.apply_central_impulse((secondfuckingchild.position-child.position).normalized()*power)
	
func are_bodies_touching(body1: RigidBody2D, body2: RigidBody2D) -> bool:
	var distance = body1.position.distance_to(body2.position)
	var radius = 20.0 * body1.scale.x
	return distance < radius * 2

func handle_temperature(delta):
	var energy_received: Dictionary = {}
	for body in thermal_bodies:
		energy_received[body] = 0.0
	# Update temperatures
	for body in thermal_bodies:
		var area = PI * (body.CollisionShape.shape.radius**2)
		
		# Energy lost to space
		var energy_lost = STEFAN_BOLTZMANN * body.emissivity * area * pow(body.temperature, 4) * delta
		
		# Net energy change
		var net_energy = energy_received[body] - energy_lost
		
		# Temperature change: ΔT = Q / (m * c)
		var delta_temp = net_energy / (body.mass * body.specific_heat)
		
		# Update temperature with some damping for stability
		body.temperature += delta_temp * 0.1
		
		# Prevent absolute zero
		body.temperature = max(2.7, body.temperature)
		
		body.update_visual()

func _on_child_entered_tree(node: Node) -> void:
	thermal_bodies.append(node)


func _on_child_exiting_tree(node: Node) -> void:
	thermal_bodies.erase(node)
