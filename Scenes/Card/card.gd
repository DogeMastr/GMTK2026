extends Node2D

class_name Card
var value = 0

func set_value(v):
	value = v

func _process(delta: float) -> void:
	$CardSprites.set_frame(value-1)
	pass
