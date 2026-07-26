extends Node2D

var nugget = preload("res://Scenes/Scale/nugget.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.spawn_nugget.connect(spawn_nugget)
	EventBus.game_over.connect(hide)

	pass # Replace with function body.

func spawn_nugget(x,y,data):
		var temp_nugget = nugget.instantiate()
		temp_nugget.with_data(data)
		#temp_nugget.z_layer = 7
		temp_nugget.position.x = x
		temp_nugget.position.y = y
		add_child(temp_nugget)

func _hide():
	visible = false
