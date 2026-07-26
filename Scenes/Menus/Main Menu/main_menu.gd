extends Control

@onready var game_scene = preload("res://Scenes/Game/Game.tscn")
@onready var main_menu_music = preload("res://Assets/Sound/Music/digdown.wav")
@onready var game_music = preload("res://Assets/Sound/Music/diggame.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.fade_music_in(main_menu_music)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_exit_pressed() -> void:
	$CenterContainer/VBoxContainer/Exit/LinkButton.pressed.emit()
	pass # Replace with function body.

func _on_play_pressed() -> void:
	AudioManager.fade_music_in(game_music)
	get_tree().change_scene_to_packed(game_scene)
	pass # Replace with function body.
