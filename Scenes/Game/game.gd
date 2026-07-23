extends Control

@export var tile_object := preload("../Tile/tile.tscn")
const width = 5
const height = 15

const scroll_scale = 0.01
const min_scroll_speed = 5
const max_scroll_speed = 100
var ideal_headroom = EventBus.tile_width*2.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for j in range(height):
		for i in range(width):
			var temp_tile = tile_object.instantiate()
			temp_tile.position.x = i*EventBus.tile_width
			temp_tile.position.y = j*EventBus.tile_width
			$TileGrid.add_child(temp_tile)
			pass
		pass
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	run_grid_scrolling(delta)
	#grid_scroll(delta)
	pass
	
var weight = 0.0
const weightDecay = 50
func run_grid_scrolling(delta):
	# theres math involved here
	# we want to be slowest when theres less than 2 tiles above the player
	# max speed when theres 7 tiles above the player
	weight = lerp(weight, $TileGrid/Mole.global_position.y/(get_viewport().size.y-ideal_headroom), delta*weightDecay)
	var scroll_speed = lerp(min_scroll_speed,max_scroll_speed,weight) * scroll_scale
	scroll_speed = clamp(scroll_speed, min_scroll_speed*scroll_scale, max_scroll_speed*scroll_scale)
	$TileGrid.position.y -= scroll_speed
	DebugGraph.plot("weight", weight*100)
	DebugGraph.plot("pos", $TileGrid/Mole.global_position.y)
	DebugGraph.plot("speed", scroll_speed)
	# https://www.youtube.com/watch?v=LSNQuFEDOyQ
	pass
