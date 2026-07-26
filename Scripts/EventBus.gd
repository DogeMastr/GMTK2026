extends Node

var tile_width = 64

signal move_down(amount_to_move: int)
signal mole_dies
signal dig_out_row
signal game_over

signal add_card(data: int)

signal spawn_nugget(x,y,data)

var score = 0
var difficulty = 0
var hand = []
var current_row = []
var mole_alive_status = true


func get_tile(x, y):
	# this is the most inefficient search i could think of youre welcome :3
	var all_tiles = get_tree().get_nodes_in_group("tile")
	for tile in all_tiles:
		if tile.y_pos == y:
			if tile.x_pos == x:
				return tile
	return null

func get_tile_row(y):
	# this is the most inefficient search i could think of youre welcome :3
	var all_tiles = get_tree().get_nodes_in_group("tile")
	var row = []
	for tile in all_tiles:
		if tile.y_pos == y:
			row.append(tile)
	return row
