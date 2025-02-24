class_name VelocidadPowerUp extends Area2D

@export var speed_multiplier := 1.5  # Cuánto se multiplica la velocidad
@export var duration := 5.0  # Duración en segundos del power-up

func _ready() -> void:
	connect("body_entered", _on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.apply_speed_boost(speed_multiplier, duration)
		queue_free()
