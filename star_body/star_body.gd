extends Thermal_body

class_name Star_body

const life_time: float = 100000000000.0

var luminosity: float = 3.827*10e13  # Power output
var core_temperature: float = 5778.0  # Kelvin

func _ready() -> void:
	temperature = 5778.0  # Солнечная температура
	mass = 100000       # БОЛЬШАЯ масса
	specific_heat = 100.0 # НИЗКАЯ теплоемкость (быстро реагируют)
	emissivity = 0.0
	albedo = 0.1
	density = 1/1000*1.4
	
	$Timer.start(mass/luminosity*life_time)

func _process(delta: float) -> void:
	$PointLight2D.energy = sqrt(temperature)/30

func _on_timer_timeout() -> void:
	emissivity = 1.0

func get_type():
	return "Star"
