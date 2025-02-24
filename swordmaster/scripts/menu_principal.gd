extends Control



@onready var button_start: Button = $VBoxContainer/ButtonStart
@onready var button_exit: Button = $VBoxContainer/ButtonExit
@onready var button_info: Button = $VBoxContainer/ButtonInfo

@onready var info_controles: Panel = $InfoControles
@onready var info_objetivo: Panel = $InfoObjetivo
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D



func _ready() -> void:
	audio_stream_player_2d.play()
	button_start.pressed.connect(_on_button_start_pressed)
	button_exit.pressed.connect(_on_button_exit_pressed)

func _on_button_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world1.tscn")


func _on_button_info_pressed() -> void:
	var new_visibility = not info_controles.visible
	info_controles.visible = new_visibility
	info_objetivo.visible = new_visibility

func _on_button_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_options.tscn")


func _on_button_exit_pressed() -> void:
	get_tree().quit()
