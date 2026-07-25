extends Node2D

var current_score = 0
# target_score is eventbus.score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_score != EventBus.score:
		current_score = EventBus.score
		var string_score = "%08d" % current_score
		#print(string_score)
		var i = 0
		for digit in get_children():
			#print(int(string_score[i]))
			digit.target_digit = int(string_score[i])
			i += 1
	pass
