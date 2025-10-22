extends Camera2D

var SPEED = 10
var ZOOMSPEED = 0.1

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var directionx := Input.get_axis("left", "right")
	var directiony := Input.get_axis("up", "down")
	if directionx:
		position.x += directionx * SPEED / zoom.x
	if directiony:
		position.y += directiony * SPEED / zoom.y
	if Input.is_action_just_pressed("scroll_up"):
		zoom += Vector2.ONE*ZOOMSPEED
	if Input.is_action_just_pressed("scroll_down") and zoom > Vector2.ONE*ZOOMSPEED:
		zoom -= Vector2.ONE*ZOOMSPEED
