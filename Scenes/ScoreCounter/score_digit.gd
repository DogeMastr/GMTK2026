extends Node2D

var target_digit = 0
var current_digit = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target_digit != current_digit:
		$AnimatedSprite2D.set_animation("scroll")
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.set_animation("default")
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.set_frame(current_digit)

	if current_digit > 9:
		current_digit = 0


func _on_animated_sprite_2d_animation_looped() -> void:
	current_digit += 1
	pass # Replace with function body.
