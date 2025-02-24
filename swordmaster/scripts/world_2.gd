extends Node2D

# Precargando las escenas de los personajes
@onready var enemy: Enemy = $Enemy
@onready var spawn_point: Marker2D = $SpawnPoint

func _ready() -> void:
	if spawn_point and get_tree().get_first_node_in_group("Player"):
		var player = get_tree().get_first_node_in_group("Player")
		player.global_position = spawn_point.global_position
	if enemy != null:
		enemy.scale = Vector2(3, 3)
	enemy.health_component.max_health = 500
	enemy.health_component.current_health = 500
	
