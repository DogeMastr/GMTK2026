extends Node2D

class_name Card
var value = 0

var target_y
var target_x
var is_selected = false

var sprite_offset_y = -64.0

func set_value(v):
	sprite_offset_y = $CardSprites.position.y
	value = v

func _process(delta: float) -> void:
	$CardSprites.set_frame(value-1)
	
	position.x = lerp(position.x, target_x, 0.3)
	position.y = lerp(position.y, target_y, 0.3)
	
	if is_selected:
		$CardSprites.position.y = lerp($CardSprites.position.y, sprite_offset_y-40, 0.3)
	else:
		$CardSprites.position.y = lerp($CardSprites.position.y, sprite_offset_y, 0.3)
	$Label.text = str(is_selected)

func set_target_position(x, y):
	target_x = x
	target_y = y


func _on_mouse_entered() -> void:
	var all_cards = get_tree().get_nodes_in_group("card")
	var is_another_selected = false
	for card in all_cards:
		if card.is_selected:
			is_another_selected = true
	is_selected = !is_another_selected
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	is_selected = false
	pass # Replace with function body.
