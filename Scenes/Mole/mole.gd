extends CharacterBody2D
class_name Mole

# these are grid positions
var x_pos = 0
var y_pos = 0

func _process(delta: float) -> void:
	# PLAYER INPUTS
	if Input.is_action_just_pressed("player_left"):
		if x_pos != 0:
			position.x -= EventBus.tile_width
			x_pos -= 1

	if Input.is_action_just_pressed("player_right"):
		if x_pos != 4:
			position.x += EventBus.tile_width
			x_pos += 1
	
	if Input.is_action_just_pressed("player_down"):
		position.y += EventBus.tile_width
		y_pos += 1
	pass
