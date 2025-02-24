extends Control
@onready var panel_options: Panel = $PanelOptions
@onready var slider_volume: HSlider = $PanelOptions/SliderVolume
@onready var icono_volume: Sprite2D = $PanelOptions/IconoVolume
@onready var button_resolution: Button = $VBoxContainer/ButtonResolution
@onready var button_exit: Button = $VBoxContainer/ButtonExit
@onready var option_button_window: OptionButton = $PanelOptions/OptionButtonWindow
@onready var icono_resolution: Sprite2D = $PanelOptions/IconoResolution
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

# Lista de tamaños de ventana disponibles
var window_sizes = {
	"800x600": Vector2i(800, 600),
	"1280x720": Vector2i(1280, 720),
	"1600x900": Vector2i(1600, 900),
	"1920x1080": Vector2i(1920, 1080)
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slider_volume.value_changed.connect(_on_slider_volume_value_changed)
	
	var saved_volume = get_volume()
	slider_volume.value = saved_volume
	_apply_volume(saved_volume)
	
	# Llenar el OptionButton con las opciones de tamaño de ventana
	var index = 0
	for resolution in window_sizes.keys():
		option_button_window.add_item(resolution, index)
		index += 1

	# Cargar y aplicar el tamaño guardado
	var saved_resolution = get_saved_window_size()
	if saved_resolution in window_sizes.values():
		apply_window_size(saved_resolution)
		option_button_window.select(get_resolution_index(saved_resolution))

	# Conectar señales
	option_button_window.item_selected.connect(_on_option_button_window_item_selected)



func _on_button_volume_pressed() -> void:
	var new_visibility = not panel_options.visible
	panel_options.visible = new_visibility
	slider_volume.visible = new_visibility
	icono_volume.visible = new_visibility


func _on_button_resolution_pressed() -> void:
	var new_visibility = not panel_options.visible
	panel_options.visible = new_visibility
	option_button_window.visible = new_visibility
	icono_resolution.visible = new_visibility


func _on_button_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_principal.tscn")


func _on_slider_volume_value_changed(value: float) -> void:
	_apply_volume(value)
	save_volume(value)
	
# Aplicar volumen al audio del juego
func _apply_volume(value: float) -> void:
	var db_value = linear_to_db(value / 100.0)  # Convierte el valor a decibeles
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db_value)

# Guardar el volumen en Configuración del Juego
func save_volume(value: float) -> void:
	var config = ConfigFile.new()
	config.set_value("audio", "volume", value)
	config.save("user://settings.cfg")

# Cargar el volumen guardado
func get_volume() -> float:
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		return config.get_value("audio", "volume", 100)  # Devuelve 100 si no hay valor guardado
	return 100  # Si no existe el archivo, usar volumen por defecto


func _on_option_button_window_item_selected(index: int) -> void:
	var selected_text = option_button_window.get_item_text(index)
	if selected_text in window_sizes:
		apply_window_size(window_sizes[selected_text])
		save_window_size(window_sizes[selected_text])
		
# Aplica el tamaño de la ventana
func apply_window_size(size: Vector2i) -> void:
	DisplayServer.window_set_size(size)
	
# Guarda el tamaño de la ventana
func save_window_size(size: Vector2i) -> void:
	var config = ConfigFile.new()
	config.set_value("video", "window_size", size)
	config.save("user://settings.cfg")

# Carga el tamaño de ventana guardado
func get_saved_window_size() -> Vector2i:
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		return config.get_value("video", "window_size", Vector2i(1280, 720))  # Valor por defecto
	return Vector2i(1280, 720)

# Obtener el índice de la resolución guardada para seleccionarla en el OptionButton
func get_resolution_index(size: Vector2i) -> int:
	var index = 0
	for res in window_sizes.values():
		if res == size:
			return index
		index += 1
	return 1  # Devuelve 1 (1280x720) si no encuentra otra
