extends Control

@onready var game_music = preload("res://Assets/Sound/Music/diggame.wav")

@onready var score = $VBoxContainer/Score

func _ready():
	visible = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	EventBus.game_over.connect(gamed_over)

func gamed_over():
	visible = true
	score.text = str(EventBus.score)
	mouse_filter = Control.MOUSE_FILTER_STOP

func _on_button_pressed() -> void:
	AudioManager.crossfade_music_to(game_music)
	get_tree().reload_current_scene()
