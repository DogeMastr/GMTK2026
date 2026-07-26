extends Control

@onready var game_scene = preload("res://Scenes/Game/Game.tscn")
@onready var main_menu_music = preload("res://Assets/Sound/Music/digdown.wav")
@onready var game_music = preload("res://Assets/Sound/Music/diggame.wav")
@onready var button_press = preload("res://Assets/Sound/soundeffects/select.wav")

@onready var button_hover = preload("res://Assets/Sound/soundeffects/hover.wav")

@onready var volume_slider = $VolumeSlider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.fade_music_in(main_menu_music)
	volume_slider.value = AudioServer.get_bus_volume_db(0) + 30


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_exit_pressed() -> void:
	$CenterContainer/VBoxContainer/Exit/LinkButton.pressed.emit()
	pass # Replace with function body.

func _on_play_pressed() -> void:
	AudioManager.fade_music_in(game_music)
	AudioManager.play_audio_one_shot(button_press, 1.0)
	get_tree().change_scene_to_packed(game_scene)
	pass # Replace with function body.


func _on_play_mouse_entered() -> void:
	AudioManager.play_audio_one_shot(button_hover, 1.0)


func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value-30)
	#print(value)
