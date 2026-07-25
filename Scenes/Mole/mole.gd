extends CharacterBody2D
class_name Mole

# these are grid positions
var x_pos = 0
var y_pos = 0

var target_y = 0
var currently_digging = false

func _ready() -> void:
	EventBus.move_down.connect(move_mole_down)
	EventBus.mole_dies.connect(death)

func _process(delta: float) -> void:
	# PLAYER INPUTS
	if Input.is_action_just_pressed("player_left") and EventBus.mole_alive_status:
		if x_pos != 0 and not EventBus.get_tile(x_pos - 1, y_pos).type == 5:
			position.x -= EventBus.tile_width
			x_pos -= 1
		if $AnimatedSprite2D.flip_h == true:
			$AnimatedSprite2D.flip_h = false

	if Input.is_action_just_pressed("player_right") and EventBus.mole_alive_status:
		if x_pos != 4 and not EventBus.get_tile(x_pos + 1, y_pos).type == 5:
			position.x += EventBus.tile_width
			x_pos += 1
		if $AnimatedSprite2D.flip_h == false:
			$AnimatedSprite2D.flip_h = true
	pass
	
	if currently_digging:
		$AnimatedSprite2D.set_animation("dig")
		position.y = lerp(position.y, target_y, 0.3)
		
		if is_equal_approx(position.y, target_y):
			position.y = target_y
			currently_digging = false
			if EventBus.mole_alive_status:
				$AnimatedSprite2D.set_animation("default")

func move_mole_down(amount_to_travel: int):
	if amount_to_travel > 0 and EventBus.mole_alive_status:
		
		for i in range(amount_to_travel):
			var tile_to_travel_to = EventBus.get_tile(x_pos, y_pos + i + 1)
			if tile_to_travel_to.type == 5:
				amount_to_travel = i
				break
			if tile_to_travel_to.type == 4 or tile_to_travel_to.type == 3:
				amount_to_travel = i + 1
				break
			if tile_to_travel_to.type == 0:
				tile_to_travel_to.type = -1
			EventBus.get_tile(x_pos,y_pos).has_been_dug_from = true
			tile_to_travel_to.has_mole = true
			#if not EventBus.get_tile(x_pos, y_pos + i).type == 5:
				#EventBus.get_tile(x_pos, y_pos + i).type = -1
				
		target_y = position.y + EventBus.tile_width * amount_to_travel
		currently_digging = true
		y_pos += amount_to_travel
		EventBus.get_tile(x_pos,y_pos).has_been_dug_into = true
		
func death():
	
	EventBus.mole_alive_status = false
	
	$AnimatedSprite2D.set_animation("death")
	await $AnimatedSprite2D.animation_changed
	print($AnimatedSprite2D.animation)
	print(currently_digging)
	$AnimatedSprite2D.set_animation("death")
