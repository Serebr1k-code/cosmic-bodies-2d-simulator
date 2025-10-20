extends Node2D

@onready var cosmic_body = preload("res://cosmic_body/cosmic body.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var balls = []
	for i in range(10):
		balls.append(cosmic_body.instantiate())
		balls[i].position = Vector2(randi_range(100, 1200), randi_range(100, 600))
		add_child(balls[i])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handle_gravity(delta)
	
func handle_gravity(delta):
	pass
