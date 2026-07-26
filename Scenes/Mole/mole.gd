extends CharacterBody2D
class_name Mole

# these are grid positions
var x_pos = 0
var y_pos = 0

var target_y = 0
var currently_digging = false

# Sound Effect
@export_group("Sound effects")
@export var death_mole_sfx: AudioStream
@export var digging_sfx: AudioStream
@export var rock_sfx: AudioStream

func _ready() -> void:
	EventBus.move_down.connect(move_mole_down)
	EventBus.mole_dies.connect(death)

func _process(delta: float) -> void:
	# PLAYER INPUTS
	if Input.is_action_just_pressed("player_left") and EventBus.mole_alive_status and not currently_digging:
		if x_pos != 0 and not EventBus.get_tile(x_pos - 1, y_pos).type == 5:
			position.x -= EventBus.tile_width
			x_pos -= 1
		if $AnimatedSprite2D.flip_h == true:
			$AnimatedSprite2D.flip_h = false
		AudioManager.play_audio_one_shot(digging_sfx, 5.0)


	if Input.is_action_just_pressed("player_right") and EventBus.mole_alive_status and not currently_digging:
		if x_pos != 4 and not EventBus.get_tile(x_pos + 1, y_pos).type == 5:
			position.x += EventBus.tile_width
			x_pos += 1
		if $AnimatedSprite2D.flip_h == false:
			$AnimatedSprite2D.flip_h = true
		AudioManager.play_audio_one_shot(digging_sfx, 5.0)

	pass
	
	if currently_digging:
		if EventBus.mole_alive_status:
			$AnimatedSprite2D.play("dig")
		position.y = lerp(position.y, target_y, 0.3)
		
		if is_equal_approx(position.y, target_y):
			position.y = target_y
			currently_digging = false
			if EventBus.mole_alive_status:
				$AnimatedSprite2D.set_animation("default")

func move_mole_down(amount_to_travel: int):
	if amount_to_travel > 0 and EventBus.mole_alive_status:
		
		for i in range(amount_to_travel):
			var tile_to_travel_to = EventBus.get_tile(x_pos, y_pos + i + 1)
			if tile_to_travel_to.type == 0:
				tile_to_travel_to.type = -1
			if tile_to_travel_to.type == 5:
				amount_to_travel = i
				AudioManager.play_audio_one_shot(rock_sfx, 2.0)

				break
			if tile_to_travel_to.type == 4 or tile_to_travel_to.type == 3:
				amount_to_travel = i + 1
				EventBus.mole_dies.emit()
				
				break
			EventBus.get_tile(x_pos,y_pos).has_been_dug_from = true
			tile_to_travel_to.has_mole = true
			
		target_y = position.y + EventBus.tile_width * amount_to_travel
		currently_digging = true
		y_pos += amount_to_travel
		EventBus.get_tile(x_pos,y_pos).has_been_dug_into = true
		AudioManager.play_audio_one_shot(digging_sfx)
		
func death():
	EventBus.mole_alive_status = false
	
	AudioManager.play_audio_one_shot(death_mole_sfx, 1.0)
	$AnimatedSprite2D.set_animation("death")
