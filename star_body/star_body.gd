extends Thermal_body

class_name Star_body

const life_time: float = 100000000000.0

var luminosity: float = 3.827*10e13  # Power output
var core_temperature: float = 5778.0  # Kelvin
var big_red_ball: bool = false
var small_white_ball: bool = false

func _ready() -> void:
	temperature = 5778.0  # Солнечная температура
	mass = 100000       # БОЛЬШАЯ масса
	specific_heat = 100.0 # НИЗКАЯ теплоемкость (быстро реагируют)
	emissivity = 0.0
	albedo = 0.1
	density = 1/1000*1.4
	
	$Timer.start(mass/luminosity*life_time)

func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	emissivity = 1.0

func get_type():
	return "Star"

func update_visual():
	if big_red_ball:
		$Sprite2D.modulate = Color.RED
	elif small_white_ball:
		$Sprite2D.modulate = Color.WHITE
	else:
		$Sprite2D.modulate = Color(min(temperature/1000, 1.0), min(temperature/2000, 0.5), max(1-temperature/1000, 0.0))

func resize(up: bool, n: float):
	if up:
		var new_collision_shape = CircleShape2D.new()
		new_collision_shape.radius = $CollisionShape2D.shape.radius * n
		$Sprite2D.scale *= n
		$CollisionShape2D.shape = new_collision_shape
	else:
		var new_collision_shape = CircleShape2D.new()
		new_collision_shape.radius = $CollisionShape2D.shape.radius / n
		$Sprite2D.scale /= n
		$CollisionShape2D.shape = new_collision_shape

func get_sprite_size():
	return $Sprite2D.scale.x
