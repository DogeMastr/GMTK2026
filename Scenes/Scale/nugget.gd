extends RigidBody2D


var launched = false
func with_data(data):
	$AnimatedSprite2D.set_frame(data-1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(global_position.y > 900):
		queue_free()
		
	if !launched:
		#print(position.x, " : ", position.y)
		# y min = -50000
		# x min = 10000
		# y max = -20000
		# x max = 25000
		var x_force = remap_range(position.x, 63, 350, 25000, 12000)
		var y_force = remap_range(position.y, 0, 600, -20000, -50000)
		apply_force(Vector2(x_force,y_force))
		launched = true
		pass
		
	$Square1.set_deferred("disabled", true)
	$Square2.set_deferred("disabled", true)
	$Square3.set_deferred("disabled", true)
	$Circle.set_deferred("disabled", true)
	
	if $AnimatedSprite2D.get_frame() == 0:
		$Square1.set_deferred("disabled", false)
	elif $AnimatedSprite2D.get_frame() == 1:
		$Square2.set_deferred("disabled", false)
	elif $AnimatedSprite2D.get_frame() == 2:
		$Square3.set_deferred("disabled", false)
	else:
		$Circle.set_deferred("disabled", false)
		


func remap_range(value: float, InputA: float, InputB: float, OutputA: float, OutputB: float):
	return(value - InputA) / (InputB - InputA) * (OutputB - OutputA) + OutputA
