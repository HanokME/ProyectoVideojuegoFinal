extends Node2D

const ENEMY = preload("res://scenes/enemy.tscn")
var time_spawn_enemy:= 10
@onready var player: Player = $Player
@onready var timer_spawn_enemy: Timer = $TimerSpawnEnemy

func _ready() -> void:
	timer_spawn_enemy.timeout.connect(spawn_enemy)
	timer_spawn_enemy.wait_time = time_spawn_enemy
	timer_spawn_enemy.start()
	
	

func spawn_enemy():
	var enemy = ENEMY.instantiate()
	
	
	#Generar un angulo aleatorio en radianes
	var random_angle: float = randf() * PI * 2
	
	#Generar distancia aleatoria dentro de un rango
	var spawn_distance: float = randf_range(270, 300)
	
	#convertir el angulo a coordenadas cartesianas aplicando la distancia para obtener el desplazamiento
	var spawn_offset: Vector2 = Vector2(cos(random_angle), sin(random_angle)) * spawn_distance
	
	#Establecer el enemigo acorde a la posicion del jugador
	enemy.position = spawn_offset + player.position
	
	add_child(enemy)
	
