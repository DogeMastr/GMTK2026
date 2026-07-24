extends CharacterBody2D
class_name Mole

# these are grid positions
var x_pos = 0
var y_pos = 0

var target_y = 0
var currently_digging = false

func _ready() -> void:
	EventBus.move_down.connect(move_mole_down)
	EventBus.mole_dies.connect(death)

func _process(delta: float) -> void:
	# PLAYER INPUTS
	if Input.is_action_just_pressed("player_left"):
		if x_pos != 0 and not EventBus.get_tile(x_pos - 1, y_pos).type == 5:
			position.x -= EventBus.tile_width
			x_pos -= 1

	if Input.is_action_just_pressed("player_right"):
		if x_pos != 4 and not EventBus.get_tile(x_pos + 1, y_pos).type == 5:
			position.x += EventBus.tile_width
			x_pos += 1
	
	#if Input.is_action_just_pressed("player_down"):
		#move_mole_down(1)
	#
	##No card player movement
	#if Input.is_action_just_pressed("1"):
		#move_mole_down(1)
	#if Input.is_action_just_pressed("2"):
		#move_mole_down(2)
	#if Input.is_action_just_pressed("3"):
		#move_mole_down(3)
	#if Input.is_action_just_pressed("4"):
		#move_mole_down(4)
	#if Input.is_action_just_pressed("5"):
		#move_mole_down(5)
	pass
	
	if currently_digging:
		position.y = lerp(position.y, target_y, 0.3)
		if position.y == target_y:
			currently_digging = false

func move_mole_down(amount_to_travel: int):
	if amount_to_travel > 0:
		EventBus.get_tile(x_pos,y_pos).dig_through_tile()
		for i in range(amount_to_travel):
			var tile_to_travel_to = EventBus.get_tile(x_pos, y_pos + i + 1)
			if tile_to_travel_to.type == 5:
				amount_to_travel = i
				break
			if tile_to_travel_to.type == 4 or tile_to_travel_to.type == 3:
				amount_to_travel = i + 1
				EventBus.mole_dies.emit()
				break
			tile_to_travel_to.has_mole = true
			#if not EventBus.get_tile(x_pos, y_pos + i).type == 5:
				#EventBus.get_tile(x_pos, y_pos + i).type = -1
				
		target_y = position.y + EventBus.tile_width * amount_to_travel
		currently_digging = true
		y_pos += amount_to_travel
		
func death():
	print("dead")
