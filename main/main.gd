extends Node2D

@onready var cosmic_body = preload("res://cosmic_body/cosmic body.tscn")
var G = 667

func _ready() -> void:
	var balls = []
	for i in range(10):
		balls.append(cosmic_body.instantiate())
		balls[i].position = Vector2(randi_range(100, 1200), randi_range(100, 600))
		balls[i].mass = randf()
		add_child(balls[i])

func _process(delta: float) -> void:
	handle_gravity(delta)

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
