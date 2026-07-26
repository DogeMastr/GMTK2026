extends Control

@onready var game_music = preload("res://Assets/Sound/Music/diggame.wav")
@onready var button_hover = preload("res://Assets/Sound/soundeffects/hover.wav")
@onready var button_press = preload("res://Assets/Sound/soundeffects/select.wav")

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
	AudioManager.play_audio_one_shot(button_press, 1.0)
	get_tree().reload_current_scene()


func _on_button_mouse_entered() -> void:
	AudioManager.play_audio_one_shot(button_hover, 1.0)
