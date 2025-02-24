class_name Tower extends CharacterBody2D

var is_attack := false
var in_attack_player_range = false
@onready var sprite_animated: AnimatedSprite2D = $Sprite2D
@onready var health_component: HealthComponent = $Components/HealthComponent
@onready var player: Player = $"../Player"





func _ready() -> void:
	health_component.death.connect(on_death)
	if player:
		player.attack_finished.connect(verify_receive_damage)
		
func verify_receive_damage():
	if in_attack_player_range:
		health_component.receive_damage(player.attack_damage)
		
func on_death():
	sprite_animated.play("destroyed")
	in_attack_player_range = false
	set_physics_process(false)

func _on_area_attack_body_entered(body: Node2D) -> void:
	if body is Player:
		in_attack_player_range = true


func _on_area_attack_body_exited(body: Node2D) -> void:
	if body is Player:
		in_attack_player_range = false
