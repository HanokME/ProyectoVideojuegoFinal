class_name VidaPowerUp extends Area2D

@export var heal_amount := 100 #vida que restaura

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.health_component.current_health < body.health_component.max_health:
			body.health_component.apply_health(heal_amount)
			queue_free()
