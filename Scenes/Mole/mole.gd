extends CharacterBody2D
class_name Mole

# these are grid positions
var x_pos = 0
var y_pos = 0

func _ready() -> void:
	EventBus.move_down.connect(move_mole_down)

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
		move_mole_down(1)
		
		
		
	pass

func move_mole_down(amount_to_travel: int):
	if amount_to_travel > 0:
		for i in range(amount_to_travel):
			var tile_to_travel_to = EventBus.get_tile(x_pos, y_pos + i + 1)
			if tile_to_travel_to.type == 5:
				amount_to_travel = i
			
		print(amount_to_travel)
		position.y += EventBus.tile_width * amount_to_travel
		y_pos += amount_to_travel
