extends Node2D

var card = preload("res://Scenes/Card/card.tscn")

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
	pass
