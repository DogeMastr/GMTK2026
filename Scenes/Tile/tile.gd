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
var data = -1

func set_type(difficulty):
	var r = randi_range(0, 100 - difficulty)
	if r < 10:
		type = 1
		data = randi_range(1,5) # gold amount
	elif r < 15:
		type = 2
		data = randi_range(1,6) # card type
	elif r < 20:
		type = 3
	elif r < 22:
		type = 4
	elif r < 28:
		type = 5
	else:
		type = 0
	pass

func _process(delta: float) -> void:
	if has_mole:
		$Sprite2D.modulate = Color(base_color.h, 0, base_color.v)
	else:
		$Sprite2D.modulate = base_color
	$Label.text = str(type)
	
	if has_mole:
		if type == 1: # Gold pick up
			EventBus.score += 1
			type = 0
		if type == 2: # Card pick up
			EventBus.add_card(data)
			$CardSprite.set_visible(false)
			type = 0
		if type == 3: #Death
			EventBus.mole_dies.emit()
			type = 0
			
		# The Lava tile is handled in game.gd in func digging_out_row()
		
		if type == 5: #Rock
			pass


	if type == 2:
		if data > 0:
			$CardSprite.set_frame(data-1)
		$CardSprite.set_visible(true)
	else:
		$CardSprite.set_visible(false)
	
func _on_body_entered(body: Node2D) -> void:
	if body is Mole:
		has_mole = true
		EventBus.current_row = EventBus.get_tile_row(body.y_pos)
		EventBus.dig_out_row.emit()
		
func _on_body_exited(body: Node2D) -> void:
	if body is Mole:
		has_mole = false
		
