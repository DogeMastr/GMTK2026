extends Node

var tile_width = 64

signal move_down(amount_to_move: int)
signal mole_dies

var score = 0
var hand = []

func add_card(data):
	# idk how we should handle this properly but im doing this for now so the tiles can work
	hand.append(data)
	
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
