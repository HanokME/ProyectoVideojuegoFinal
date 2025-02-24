extends Control
@onready var button_rerun: Button = $VBoxContainer/ButtonRerun
@onready var button_exit: Button = $VBoxContainer/ButtonExit
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_rerun.pressed.connect(_on_button_rerun_pressed)
	button_exit.pressed.connect(_on_button_exit_pressed)


func _on_button_rerun_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world1.tscn")


func _on_button_exit_pressed() -> void:
	get_tree().quit()
