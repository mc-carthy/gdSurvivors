extends CharacterBody2D

const MAX_SPEED: float = 200;

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	var movement_vector: Vector2 = get_movement_vector()
	var direction = movement_vector.normalized()
	
	velocity = direction * MAX_SPEED
	
	move_and_slide()

func get_movement_vector() -> Vector2:
	var x_movement = Input.get_action_strength('move_right') - Input.get_action_strength('move_left')
	var y_movement = Input.get_action_strength('move_down') - Input.get_action_strength('move_up')
	
	return Vector2(x_movement, y_movement)
