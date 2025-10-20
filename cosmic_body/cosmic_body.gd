extends RigidBody2D

signal apply_impulse(vec)

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _on_apply_impulse(vec: Vector2) -> void:
	apply_central_impulse(vec)
