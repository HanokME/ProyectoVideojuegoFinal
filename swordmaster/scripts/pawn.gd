class_name Pawn extends CharacterBody2D

var move_speed := 50
var attack_damage := 33
var is_attack := false
var in_attack_player_range = false
@onready var sprite_animated: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_component: HealthComponent = $Components/HealthComponent
@onready var player: Player = $"../Player"


func _ready() -> void:
	health_component.death.connect(on_death)
	if player:
		player.attack_finished.connect(verify_receive_damage)

func _physics_process(delta: float) -> void:
	if !is_attack and player:
		sprite_animated.play("run")
		
		var move_direction = (player.position - position).normalized()
		
		if move_direction:
			velocity = move_direction * move_speed
			
			if move_direction.x != 0:
				sprite_animated.flip_h = move_direction.x < 0
				$AreaAttack.scale.x = -1 if move_direction.x < 0 else 1
			
		move_and_slide()
		
func attack():
	var attack_direction = (player.position - position).normalized()
	is_attack = true

	if attack_direction.y < 0:
		sprite_animated.play("attack_up")
	else:
		sprite_animated.play("attack")
	sprite_animated.flip_h = attack_direction.x < 0
	$AreaAttack.scale.x = -1 if attack_direction.x < 0 else 1
	
	
func verify_receive_damage():
	if in_attack_player_range:
		health_component.receive_damage(player.attack_damage)

#Cuando el player entra en la zona de ataque del enemigo
func _on_area_attack_body_entered(body: Node2D) -> void:
	if body is Player:
		attack()
		
#Cuando el player sale de la zona de ataque
func _on_area_attack_body_exited(body: Node2D) -> void:
	if body is Player:
		is_attack = false
		
#Cuando termine de atacar
func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite_animated.animation.begins_with("attack"):
		player.health_component.receive_damage(attack_damage)
		is_attack = false
		if in_attack_player_range:
			attack()
			
func on_death():
	queue_free()
