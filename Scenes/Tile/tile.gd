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
var has_been_dug_from = false
var has_been_dug_into = false
var is_lava = false

@export_group("Sound Effects")
@export var coin_get: AudioStream
@export var coin_empty: AudioStream
@export var coinfull: AudioStream
@export var grub_1: AudioStream
@export var grub_2: AudioStream
@export var grub_3: AudioStream
@export var lava: AudioStream

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
			EventBus.score += entity_data
			type = -1
		if type == 2: # Card pick up
			EventBus.add_card.emit(entity_data)
			$EntitySprite.set_visible(false)
			type = -1
		if type == 3: #Death
			EventBus.mole_dies.emit()
			$EntitySprite.set_visible(false)
		if type == 4:
			EventBus.mole_dies.emit()

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
		$EntitySprite.set_visible(true)
		$EntitySprite.set_animation("hazard")
		$EntitySprite.set_frame(1)
	elif type == 4:
		$Background.set_frame(1)
		if not is_lava:
			$EntitySprite.set_visible(true)
			$EntitySprite.set_animation("hazard")
			$EntitySprite.set_frame(0)
		else:
			$EntitySprite.set_visible(false)
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
		
		EventBus.current_row = EventBus.get_tile_row(body.y_pos)
		EventBus.dig_out_row.emit()
		
func _on_body_exited(body: Node2D) -> void:
	if body is Mole:
		has_mole = false
	
func is_diggable(tile):
	if tile == null:
		return false
	if tile.type == -1 or tile.type == 4 or tile.type == 5:
		return true
	return false

func is_empty(tile):
	if tile == null:
		return false
	if tile.type == -1:
		return true
	return false

func digged_horizontally(tile):
	if not tile == null:
		if (tile.dirt_data == 1 or tile.dirt_data == 2 or tile.dirt_data == 4 or tile.dirt_data == 5):
			return true
		else:
			return false
	else:
		return false
	
func get_dirt_data():
	var N_tile = EventBus.get_tile(x_pos, y_pos-1)
	var S_tile = EventBus.get_tile(x_pos, y_pos+1)
	var E_tile = EventBus.get_tile(x_pos-1, y_pos)
	var W_tile = EventBus.get_tile(x_pos+1, y_pos)

	
	var directions = [is_diggable(N_tile), is_diggable(S_tile), (is_diggable(E_tile) or is_diggable(W_tile))]
	var emptys = [is_empty(N_tile), is_empty(S_tile), (is_empty(E_tile) or is_empty(W_tile))]
	
	if type == -1 :
		match directions:
			[true, true, true]:
				if has_been_dug_from and has_been_dug_into:
					return 5
				elif has_been_dug_from:
					return 1
				elif has_been_dug_into:
					return 2
				elif not emptys == [true, true, true]:
					return get_dirt_data_emptys(emptys, E_tile, W_tile)
				else:
					return 4
			[true, false, true]:
				if has_been_dug_into:
					return 2
				else:
					return 4
			[false, true, true]:
				if has_been_dug_from: 
					return 1
				else:
					return 4
			[true, true, false]:
				return 3
			[false, false, true]:
				return 4
			_:
				return 0
				
	elif (type == 4) or (type == 5):
		if directions == [true, false, true] :
			if N_tile.type == 5:
				return 4
			if has_been_dug_into and type == 4:
				return 2
			if type == 5 and (digged_horizontally(E_tile) or digged_horizontally(W_tile)):
				return 0
			else:
				return 4
		elif is_lava:
			return 4
		else:
			return 0

	else:
		return 0
			

func check_if_off_screen_and_die():
	if global_position.y < -550:
		queue_free()
		
func get_dirt_data_emptys(directions, E_tile, W_tile):
	match directions:
			[true, true, true]:
				if has_been_dug_from and has_been_dug_into:
					return 5
				elif has_been_dug_from:
					return 1
				elif has_been_dug_into:
					return 2
				elif not (E_tile == null or W_tile == null):
					return 3
				else:
					return 4
			[true, false, true]:
				if has_been_dug_into:
					return 2
				else:
					return 4
			[false, true, true]:
				if has_been_dug_from: 
					return 1
				else:
					return 4
			[true, true, false]:
				return 3
			[false, false, true]:
				return 4
			_:
				return 0
