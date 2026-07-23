extends Node

const mute_db := -80.0 # To mute the audio player
const default_music_db := 0.0 # This is for normal volume
const fade_time := 3.0 # The time it takes to fade in/out in seconds

var current_music_player : AudioStreamPlayer # the current player

@onready var audio_stream_01 : AudioStreamPlayer = $AudioStreamPlayer1
@onready var audio_stream_02 : AudioStreamPlayer = $AudioStreamPlayer2

func _ready() -> void:
	current_music_player = audio_stream_01
	
func fade_music_in(track: AudioStream) -> void:
	current_music_player.stream = track # Specify the song
	current_music_player.volume_db = mute_db # Mute the player
	current_music_player.play(85) # Start playing
	# Use tweens for transition:
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(current_music_player, "volume_db", default_music_db, fade_time)
	
func fade_music_out() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property(current_music_player, "volume_db", mute_db, fade_time)
	
func crossfade_music_to(track: AudioStream) -> void:
	fade_music_out() # Fade out first player
	
	# Switch current Player:
	current_music_player = audio_stream_01 if current_music_player == audio_stream_02 else audio_stream_02
	
	fade_music_in(track) # Fade in second player
