extends Node2D

var current_level = 0
# target_score is eventbus.score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.game_over.connect(hide)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_level != EventBus.difficulty:
		current_level = EventBus.difficulty
		var string_level = "%02d" % current_level
		#print(string_score)
		var i = 0
		for digit in get_children():
			#print(int(string_score[i]))
			digit.target_digit = int(string_level[i])
			i += 1
	pass

func _hide():
	visible = false
