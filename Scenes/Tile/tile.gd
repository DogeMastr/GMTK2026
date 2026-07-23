extends Node2D

class_name Tile

var has_mole = false
var base_color = Color(0.779, 0.565, 0.415, 1.0)

func _process(delta: float) -> void:
	if has_mole:
		$Sprite2D.modulate = Color(base_color.h, 0, base_color.v)
	else:
		$Sprite2D.modulate = base_color

func _on_body_entered(body: Node2D) -> void:
	if body is Mole:
		has_mole = true
		
func _on_body_exited(body: Node2D) -> void:
	if body is Mole:
		has_mole = false
		
