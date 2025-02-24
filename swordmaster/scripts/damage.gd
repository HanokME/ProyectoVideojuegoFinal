class_name DamagePowerUp extends Area2D

@export var damage_multiplier := 2.5  # Aumento del 50% en el daño
@export var duration := 15.0  # Duración del efecto en segundos

func _ready() -> void:
	connect("body_entered", _on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.apply_damage_boost(damage_multiplier, duration)
		queue_free()
