extends Control

@export var tile_object := preload("../Tile/tile.tscn")

@onready var main_menu_music = preload("res://Assets/Sound/Music/digdown.wav")
@onready var game_music = preload("res://Assets/Sound/Music/diggame.wav")
@onready var game_over_music = preload("res://Assets/Sound/Music/diggameover.wav")

const width = 5
var height = 15

const scroll_scale = 0.01
const min_scroll_speed = 5
const max_scroll_speed = 200
var ideal_headroom = EventBus.tile_width*2.5

# this value increases as the game progresses, controls the scale of the random tile generations


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for j in range(height):
		for i in range(width):
			$TileGrid.add_child(generate_tile(i, j, EventBus.difficulty))
			pass
		pass
	pass # Replace with function body.
	EventBus.dig_out_row.connect(digging_out_row)
	AudioManager.fade_music_in(game_music)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	run_grid_scrolling(delta)
	if $TileGrid/Mole.y_pos + 15 > height:
		generate_row()
	pass
	$ScoreLabel.text = "Score: " + str(EventBus.score)
	$DiffLabel.text = "Difficulty: " + str(EventBus.difficulty)
	
	
func generate_row():
	for i in range(width):
		$TileGrid.add_child(generate_tile(i, height, EventBus.difficulty))
	height += 1
	pass

func generate_tile(x, y, difficulty):
	var temp_tile = tile_object.instantiate()
	temp_tile.position.x = x*EventBus.tile_width
	temp_tile.x_pos = x
	temp_tile.position.y = y*EventBus.tile_width
	temp_tile.y_pos = y
	# run tile randomness generation here
	temp_tile.set_type(difficulty)
	if temp_tile.y_pos <= 3:
		temp_tile.type = 0
	return temp_tile

func digging_out_row():
	for row_tile in EventBus.current_row:
		if row_tile.type == 4:
			flow_lava(EventBus.current_row)
			EventBus.mole_dies.emit()
			break
		if not row_tile.type == 5 or not row_tile.type == 3:
			row_tile.type = -1
			pass
	

func flow_lava(row):
	for row_tile in row:
		row_tile.type = 4
		row_tile.is_lava = true
		#row_tile.get_node("DirtSprite").set_visible(false)
		#row_tile.get_node("EntitySprite").set_visible(false)

var weight = 0.0
const weight_decay = 50
func run_grid_scrolling(delta):
	# theres math involved here
	# we want to be slowest when theres less than 2 tiles above the player
	# max speed when theres 7 tiles above the player
	#var player_distance = $TileGrid/Mole.global_position.y/(get_viewport().size.y)
	var player_distance = remap_range($TileGrid/Mole.global_position.y, ideal_headroom, get_viewport().size.y, 0, 1)
	weight = lerp(weight, player_distance, delta*weight_decay)
	var scroll_speed = lerp(min_scroll_speed,max_scroll_speed,weight) * scroll_scale
	scroll_speed = clamp(scroll_speed, min_scroll_speed*scroll_scale, max_scroll_speed*scroll_scale)
	$TileGrid.position.y -= scroll_speed
	DebugGraph.plot("weight", weight*100)
	DebugGraph.plot("pos", player_distance)
	DebugGraph.plot("speed", scroll_speed)
	# https://www.youtube.com/watch?v=LSNQuFEDOyQ
	pass

func remap_range(value: float, InputA: float, InputB: float, OutputA: float, OutputB: float):
	return(value - InputA) / (InputB - InputA) * (OutputB - OutputA) + OutputA
