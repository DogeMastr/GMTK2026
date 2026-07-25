extends RigidBody2D

var static_y
var static_x

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	static_y = position.y
	static_x = position.x
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position.y = static_y
	position.x = static_x
	pass
