extends Node2D

#signals

#onready
@onready var cosmic_body = preload("res://cosmic_body/cosmic body.tscn")
@onready var star_body = preload("res://star_body/star_body.tscn")

@onready var Mass_label = $Area2D/BodyInfo/VBoxContainer/Mass
@onready var Radius_label = $Area2D/BodyInfo/VBoxContainer/Radius
@onready var Temperature_label = $Area2D/BodyInfo/VBoxContainer/Temperature
@onready var Type_label = $Area2D/BodyInfo/VBoxContainer/Type
@onready var Star_lifetime_label = $Area2D/BodyInfo/VBoxContainer/Star_lifetime

#const
const STEFAN_BOLTZMANN: float = 5.67e-8
const G = 6.6743

#vars
var thermal_bodies: Array[Thermal_body] = []
var star_bodies: Array[Star_body] = []
var target_body: Thermal_body
var paused: bool = false
var respawn_time: float = 0.0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	respawn_time -= delta
	if respawn_time < 0: respawn_time = 0
	handle_gravity(delta)
	handle_temperature(delta)
	handle_ui(delta)
	handle_shatter(delta)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("mouse1") and respawn_time == 0:
		add_body(1)
		respawn_time = .05
	elif Input.is_action_just_pressed("mouse2") and respawn_time == 0:
		add_body(2)
		respawn_time = .05

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
	for body in thermal_bodies:
		var total_energy_received = 0.0
		
		for body2 in thermal_bodies:
			if body == body2:
					continue
			if body2 is Star_body:
				var star_distance = body2.global_position.distance_to(body.global_position)
				if star_distance < 1.0:
					continue
				
				# Inverse square law for radiation
				var received_power = body2.luminosity / (PI * star_distance * star_distance)
				var absorbed_power = received_power * (1.0 - body.albedo) * delta
				total_energy_received += absorbed_power
			else:
				var distance = max(body.position.distance_to(body2.position), 1.0)
				
				# Угловой коэффициент (упрощенно)
				var area1 = PI * body.CollisionShape.shape.radius * body.CollisionShape.shape.radius
				var area2 = PI * body2.CollisionShape.shape.radius * body2.CollisionShape.shape.radius
				var view_factor = min(area1, area2) / (4.0 * PI * distance * distance)
				
				# Теплообмен
				var received_power = STEFAN_BOLTZMANN * body.emissivity * body2.emissivity * area1 * view_factor * (pow(body.temperature, 4) - pow(body2.temperature, 4)) * delta
				var absorbed_power = received_power * (1.0 - body.albedo) * delta
				total_energy_received += absorbed_power
		
		var area = PI * body.CollisionShape.shape.radius * body.CollisionShape.shape.radius
		# Energy lost to space
		var energy_lost = STEFAN_BOLTZMANN * body.emissivity * area * pow(body.temperature, 4) * delta
		# Net energy change
		var net_energy = total_energy_received - energy_lost
		
		# Temperature change: ΔT = Q / (m * c)
		var delta_temp = net_energy / (body.mass * body.specific_heat)
		
		# Update temperature
		body.temperature += delta_temp
		
		# Prevent absolute zero and INF
		body.temperature = max(2.7, body.temperature)
		body.temperature = min(body.temperature, 1e30)  # Максимальный предел
		
		body.update_visual()

func handle_ui(delta):
	$Area2D.global_position = get_global_mouse_position()
	if target_body:
		$Area2D/BodyInfo.show()
		Mass_label.text = "Mass: " + str(target_body.mass)
		Radius_label.text = "Radius: " + str(target_body.CollisionShape.shape.radius)
		Temperature_label.text = "Temperature: " + str(target_body.temperature)
		Type_label.text = "Type: " + str(target_body.get_type())
		if target_body is Star_body:
			Star_lifetime_label.show()
			Star_lifetime_label.text =  "Star lifetime: " + str(target_body.timer.time_left)
		else:
			Star_lifetime_label.hide()
	else:
		$Area2D/BodyInfo.hide()

func handle_shatter(delta):
	for body in get_children():
		if body is Star_body:
			if (body.temperature < 500 or body.big_red_ball) and body.get_sprite_size() <= 6 and !body.small_white_ball:
				body.mass *= 1.01
				body.resize(true, 1.005)
				body.luminosity *= 1.5
				body.temperature *= 1.5
				body.big_red_ball = true
			elif (body.big_red_ball or body.small_white_ball) and body.get_sprite_size() > 0.5:
				body.small_white_ball = true
				body.big_red_ball = false
				body.resize(false, 1.01)
				body.luminosity /= 1.005
				body.temperature /= 1.01
			elif body.small_white_ball:
				shatter_body(body, Vector2.ZERO, 10)
				
		elif body is Thermal_body:
			if body.temperature > 10000:
				if body.CollisionShape.shape.radius < 6:
					body.queue_free()
				else:
					shatter_body(body, Vector2.ZERO, 2)

func add_body(id):
	if id == 1:
		var body = cosmic_body.instantiate()
		body.position = get_global_mouse_position()
		add_child(body)
	elif id == 2:
		var body = star_body.instantiate()
		body.position = get_global_mouse_position()
		add_child(body)

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


func _on_area_2d_body_entered(body: Node2D) -> void:
	target_body = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	target_body = null

func shatter_body(body: Thermal_body, point: Vector2, count: int):
	var original_volume = PI * (body.CollisionShape.shape.radius **2)
	var fragment_volume = original_volume / count
	
	for i in range(count):
		var fragment: Thermal_body = cosmic_body.instantiate()
		if body is Star_body:
			fragment = star_body.instantiate()
		
		var fragment_scale = sqrt(fragment_volume/PI)
		var new_collision_shape = CircleShape2D.new()
		new_collision_shape.radius = fragment_scale
		
		add_child(fragment)
		
		fragment.global_position = body.global_position + Vector2(randf_range(-body.CollisionShape.shape.radius/2, body.CollisionShape.shape.radius/2), randf_range(-body.CollisionShape.shape.radius/2, body.CollisionShape.shape.radius/2))
		fragment.mass = body.mass / count
		
		fragment.CollisionShape.shape = new_collision_shape
		fragment.Sprite.scale = Vector2(fragment_scale/64, fragment_scale/64)
		if body is Star_body:
			fragment.Sprite.scale *= 1.158 / 2
		
		var direction = (fragment.global_position - body.global_position-point).normalized()
		
		fragment.apply_central_impulse(direction * 66600 / fragment.mass)
		
		
	
	body.queue_free()
