extends Node2D

# Precargando las escenas de los personajes
const ENEMY = preload("res://scenes/enemy.tscn")
const PAWN = preload("res://scenes/pawn.tscn")
const TOWER = preload("res://scenes/tower.tscn")

var time_spawn_enemy := 10
@onready var player: Player = $Player
@onready var timer_spawn_enemy: Timer = $TimerSpawnEnemy




func _ready() -> void:
	player.tileMap = $ground2
	timer_spawn_enemy.timeout.connect(spawn_enemy)
	timer_spawn_enemy.wait_time = time_spawn_enemy
	timer_spawn_enemy.start()

func spawn_enemy():
	var enemy = ENEMY.instantiate()
	var pawn = PAWN.instantiate()
	var tower = TOWER.instantiate()

	# Generando un ángulo aleatorio en radianes
	var random_angle_enemy: float = randf() * PI * 2
	var random_angle_pawn: float = fposmod(random_angle_enemy + PI, PI * 2)

	# Generando una distancia aleatoria dentro de un rango
	var spawn_distance: float = randf_range(180, 200)

	# Convertiendo el ángulo a coordenadas cartesianas para obtener el desplazamiento
	var spawn_offset_enemy: Vector2 = Vector2(cos(random_angle_enemy), sin(random_angle_enemy)) * spawn_distance
	var spawn_offset_pawn: Vector2 = Vector2(cos(random_angle_pawn), sin(random_angle_pawn)) * spawn_distance

	# Aplicando un pequeño desplazamiento aleatorio para cada personaje para evitar superposición
	var offset_enemy = Vector2(randf_range(-10, 10), randf_range(-10, 10))
	var offset_pawn = Vector2(randf_range(-50, 50), randf_range(-50, 50))

	# Estableciendo la posición del enemigo y del pawn relativa a la posición del jugador
	enemy.position = player.position + spawn_offset_enemy + offset_enemy
	pawn.position = player.position + spawn_offset_pawn + offset_pawn

	add_child(enemy)
	add_child(pawn)
	add_child(tower)

# Esta función es llamada cuando el enemigo muere
func on_death():
	queue_free()  # Libera el nodo cuando muere
