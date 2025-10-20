extends RigidBody2D

signal apply_impulse(vec)

func _ready() -> void:
	$Sprite2D.scale = Vector2.ONE*mass
	$CollisionShape2D.scale = Vector2.ONE*mass

func _process(delta: float) -> void:
	pass


func _on_apply_impulse(vec: Vector2) -> void:
	apply_central_impulse(vec)
