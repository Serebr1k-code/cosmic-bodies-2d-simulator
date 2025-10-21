extends Node2D

#signals

#onready
@onready var cosmic_body = preload("res://cosmic_body/cosmic body.tscn")

#const
const STEFAN_BOLTZMANN: float = 5.67e-8
const G = 1

#vars
var thermal_bodies: Array[Thermal_body] = []
var star_bodies: Array[Star_body] = []

func _ready() -> void:
	var balls = []
	for i in range(100):
		balls.append(cosmic_body.instantiate())
		balls[i].position = Vector2(randi_range(-3000, 3000), randi_range(-3000, 3000))
		balls[i].temperature = randi_range(50, 1050)
		add_child(balls[i])
		balls[i].apply_central_impulse(Vector2(randf(), randf())*randf_range(1, 1000))

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
	# First, calculate energy received by each body
	var energy_received: Dictionary = {}
	
	for body in thermal_bodies:
		energy_received[body] = 0.0
	
	# Calculate radiation from stars to all bodies
	for star in star_bodies:
		for body in thermal_bodies:
			if body == star:
				continue
				
			var distance = star.global_position.distance_to(body.global_position)
			if distance < 0.1:  # Avoid division by zero
				continue
				
			# Inverse square law for radiation
			var radiation_power = star.luminosity
			var received_power = radiation_power / (4.0 * PI * distance * distance)
			
			# Account for body's albedo (reflection)
			var absorbed_power = received_power * (1.0 - body.albedo)
			
			# Greenhouse effect for planets
			#if body is Planet:
				#absorbed_power *= (1.0 + body.atmosphere_thickness * 0.1)
			
			energy_received[body] += absorbed_power * delta
	
	# Calculate mutual radiation between close bodies
	for i in range(thermal_bodies.size()):
		var body1 = thermal_bodies[i]
		
		for j in range(i + 1, thermal_bodies.size()):
			var body2 = thermal_bodies[j]
			
			var distance = body1.global_position.distance_to(body2.global_position)
			if distance < 50.0:  # Only consider close bodies
				# Simple thermal radiation exchange
				var area1 = PI * body1.CollisionShape.shape.radius **2
				var area2 = PI * body2.CollisionShape.shape.radius **2
				
				# Body1 radiates to Body2
				var power1_to_2 = STEFAN_BOLTZMANN * body1.emissivity * area1 * pow(body1.temperature, 4)
				energy_received[body2] += power1_to_2 * delta / (distance * distance)
				
				# Body2 radiates to Body1  
				var power2_to_1 = STEFAN_BOLTZMANN * body2.emissivity * area2 * pow(body2.temperature, 4)
				energy_received[body1] += power2_to_1 * delta / (distance * distance)
	
	# Update temperatures
	for body in thermal_bodies:
		var area = PI * body.CollisionShape.shape.radius **2
		
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
	if node is Thermal_body:
		thermal_bodies.append(node)
		if node is Star_body:
			star_bodies.append(node)


func _on_child_exiting_tree(node: Node) -> void:
	if node is Thermal_body:
		thermal_bodies.erase(node)
		if node is Star_body:
			star_bodies.append(node)
