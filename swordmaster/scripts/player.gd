class_name Player extends CharacterBody2D

signal attack_finished

@onready var sprite_animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_component: HealthComponent = $Components/HealthComponent
@onready var tileMap: TileMapLayer



var move_speed := 100
var stair_speed := 75
var attack_damage := 60
var is_attack := false

func _ready() -> void:
	if tileMap == null:
		print("⚠️ tileMap no está asignado en el Inspector. Buscando en la escena...")
		tileMap = get_tree().get_first_node_in_group("TileMap")  # Busca un nodo con este grupo
	if tileMap:
		print("✅ tileMap encontrado:", tileMap.name)
	else:
		print("❌ No se encontró tileMap en la escena. Asignarlo manualmente en el Inspector.")
	health_component.death.connect(on_death)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				attack()
				
func _physics_process(delta: float) -> void:
	if !is_attack:
		var move_direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		
		if "stair" in get_tile_name():
			if move_direction.y != 0:
				velocity = move_direction * stair_speed
			else:
				velocity.y = 0
		else:
			if move_direction:
				velocity = move_direction * move_speed
				sprite_animation.play("run")
				if move_direction.x != 0:
					sprite_animation.flip_h = move_direction.x < 0
					$AreaAttack.scale.x = -1 if move_direction.x < 0 else 1
			else:
				velocity = velocity.move_toward(Vector2.ZERO, move_speed)
				sprite_animation.play("idle")
			
		move_and_slide()
				
func attack():
	var attack_direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	is_attack = true
	if attack_direction.y != 0:
		if attack_direction.y > 0:
			sprite_animation.play("attack_down")
		else:
			sprite_animation.play("attack_up")
	else:
		sprite_animation.play("attack")
		sprite_animation.flip_h = attack_direction.x < 0
		$AreaAttack.scale.x = -1 if attack_direction.x < 0 else 1
		

func on_death():
	get_tree().paused = true

func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite_animation.animation == "attack" or sprite_animation.animation == "attack_up" or sprite_animation.animation == "attack_down":
		is_attack = false
		attack_finished.emit()


#Enemigo en zona de ataque
func _on_area_attack_body_entered(body: Node2D) -> void:
	if body is Enemy or body is Pawn or body is Casa or body is Tower:
		body.in_attack_player_range = true

		

#Enemigo fuera de la zona de ataque
func _on_area_attack_body_exited(body: Node2D) -> void:
	if body is Enemy or body is Pawn or body is Casa or body is Tower:
		body.in_attack_player_range = false
		


func get_tile_name() -> String:
# Verificar si tileMap está asignado
	if tileMap == null:
		print("⚠️ tileMap es NULL. Asegúrate de asignarlo en el Inspector o en World.gd.")
		return ""

# Ajuste de posición para detectar el tile en el que está el Player
	var search_position = global_position + Vector2(0, 10)
	var tile_pos = tileMap.local_to_map(search_position)

	# Obtener los datos del tile en la capa 0 (ajústalo si usas otra capa)
	var tile_data = tileMap.get_cell_tile_data(tile_pos)

	if tile_data:
		var tile_name = tile_data.get_custom_data("tileName")  # Obtener el nombre del tile
		print("✅ Tile detectado:", tile_name)
		return tile_name

	print("⚠️ No se encontró tileData en", tile_pos)
	return ""	
