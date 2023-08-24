extends Node2D

const TWEEN_DURATION: float = 3
const NUM_ROTATIONS: float = 2
const MAX_RADIUS: float = 100

@onready var hitbox_component: HitboxComponent = $HitboxComponent

var base_rotation: Vector2

func _ready() -> void:
	var tween = create_tween()
	tween.tween_method(tween_method, 0.0, NUM_ROTATIONS, TWEEN_DURATION)
	tween.tween_callback(queue_free)
	base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))


func tween_method(rotations: float) -> void:
	var percent = rotations / NUM_ROTATIONS
	var current_radius = percent * MAX_RADIUS
	var current_direction = base_rotation.rotated(rotations * TAU)
	
	var player = get_tree().get_first_node_in_group('player') as Node2D
	if player == null: return

	global_position = player.global_position + (current_direction * current_radius)
