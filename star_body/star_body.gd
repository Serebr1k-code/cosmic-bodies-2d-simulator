extends Thermal_body

class_name Star_body

var luminosity: float = 1000.0  # Power output
var core_temperature: float = 5778.0  # Kelvin

func _ready() -> void:
	temperature = 5778.0  # Солнечная температура
	mass = 100000.0       # БОЛЬШАЯ масса
	specific_heat = 100.0 # НИЗКАЯ теплоемкость (быстро реагируют)
	emissivity = 1.0
	albedo = 0.1
