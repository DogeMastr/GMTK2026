extends Node2D

class_name Tile

var has_mole = false
var base_color = Color(0.779, 0.565, 0.415, 1.0)

var x_pos
var y_pos

# types of tile
# 0 Empty: you nothing				leftover%
# 1 Gold: you score					10%
# 2 Card: you pick up				5%
# 3 Death: you die					5%
# 4 Lava: you die but different		2%
# 5 Rock / stick: you stop			5%
var type = 0
var entity_data = -1
var dirt_data = 0

func set_type(difficulty):
	var r = randi_range(0, 100 - difficulty)
	if r < 10:
		type = 1
		entity_data = randi_range(1,5) # gold amount
	elif r < 15:
		type = 2
		entity_data = randi_range(1,6) # card type
	elif r < 20:
		type = 3
	elif r < 22:
		type = 4
	elif r < 28:
		type = 5
		entity_data = randi_range(2, 5)
	else:
		type = 0
	pass

func _ready() -> void:
	$DirtSprite.set_animation("dirt_frames")

func _process(delta: float) -> void:
	check_if_off_screen_and_die()
#	if has_mole:
#		$Sprite2D.modulate = Color(base_color.h, 0, base_color.v)
#	else:
#		$Sprite2D.modulate = base_color
	$Label.text = str(type)
	
	if has_mole:
		if type == 1: # Gold pick up
			EventBus.score += 1
		if type == 2: # Card pick up
			EventBus.add_card.emit(entity_data)
			$EntitySprite.set_visible(false)
		if type == 3: #Death
			EventBus.mole_dies.emit()
			$EntitySprite.set_visible(false)
		if type != 5:
			type = -1
		
		if type == 5: #Rock
			pass

	if type == 1:
		$EntitySprite.set_animation("gold")
		if entity_data > 0:
			$EntitySprite.set_frame(entity_data-1)
		$EntitySprite.set_visible(true)
	elif type == 2:
		$EntitySprite.set_animation("cards")
		if entity_data > 0:
			$EntitySprite.set_frame(entity_data-1)
		$EntitySprite.set_visible(true)
	elif type == 3:
		$EntitySprite.set_animation("hazard")
		$EntitySprite.set_frame(1)
	elif type == 4:
		$Background.set_frame(1)
		$EntitySprite.set_animation("hazard")
		$EntitySprite.set_frame(0)
	elif type == 5:
		$EntitySprite.set_animation("hazard")
		$EntitySprite.set_frame(entity_data)
	else:
		$EntitySprite.set_visible(false)
	
	dirt_data = get_dirt_data()
	$DirtSprite.set_frame(dirt_data)
	
func _on_body_entered(body: Node2D) -> void:
	if body is Mole:
		has_mole = true
		dirt_data = 4
		EventBus.current_row = EventBus.get_tile_row(body.y_pos)
		EventBus.dig_out_row.emit()
		
func _on_body_exited(body: Node2D) -> void:
	if body is Mole:
		has_mole = false

func get_dirt_data():
	var N = 0
	var S = 0
	var E = 0
	var W = 0
	
	var N_data = false
	var S_data = false
	
	var N_tile = EventBus.get_tile(x_pos, y_pos-1)
	var S_tile = EventBus.get_tile(x_pos, y_pos+1)
	var E_tile = EventBus.get_tile(x_pos-1, y_pos)
	var W_tile = EventBus.get_tile(x_pos+1, y_pos)
	
	
	#3578 are "dug from" tiles
	if y_pos - 1 >= 0 and N_tile != null:
		N = N_tile.type
		N_data = is_dug_from_tile(N_tile.dirt_data)
	if y_pos + 1 <= 4 and S_tile != null:
		S = S_tile.type
		S_data = is_dug_from_tile(S_tile.dirt_data)
	if x_pos - 1 >= 0 and E_tile != null:
		W = E_tile.type
	if x_pos + 1 <= 4 and W_tile != null:
		E = W_tile.type

	if (E == -1 or W == -1) and type == -1:
		if N_data and S_data:
	#if EW are empty and N is true and S is true, 5
			return 5
		elif N_data and not S_data:
	#if EW are empty and N is true and S is false, 2
			return 2
		elif not N_data and S_data:
	#if EW are empty and N is not true and S is true, 3
			return 3
		else:
	#if EW are empty and N is not true and S is not true, 4
			return 4
	else:
		if (N == -1 or S == -1) and type == -1:
	#if NS are empty and EW are not empty, 3
			return 3
		else:
	#if NSEW are not empty, 0
			return 0
	pass

func is_dug_from_tile(tile_data):
	if tile_data == 2 or tile_data == 3 or tile_data == 5 or tile_data == 6:
		return true
	else:
		return false

func dig_through_tile():
	if dirt_data == 2:
		dirt_data = 5
	if dirt_data == 4:
		dirt_data = 1

func check_if_off_screen_and_die():
	if global_position.y < -550:
		queue_free()
