extends Node2D

var card = preload("res://Scenes/Card/card.tscn")
const max_hand_size = 7
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.add_card.connect(add_card)
	pass # Replace with function body.

func add_card(data):
	var temp_card = card.instantiate()
	temp_card.set_value(data)
	add_child(temp_card)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var card_count = get_children().size()
	for i in range(card_count):
		# 0 is the center
		# with two cards, -0.5, 0.5
		# with three cards -1, 0, 1
		# with four cards -1.5, -0.5, 0.5, 1.5
		var x_pos = remap_range(float(i), 0, card_count, -max_hand_size/2, max_hand_size/2)
		get_child(i).position.x = x_pos * 64
		get_child(i).rotation = deg_to_rad(x_pos * 5)
		get_child(i).position.y = abs(x_pos) * 5
		
		
		pass
	pass

func remap_range(value: float, InputA: float, InputB: float, OutputA: float, OutputB: float):
	return(value - InputA) / (InputB - InputA) * (OutputB - OutputA) + OutputA
