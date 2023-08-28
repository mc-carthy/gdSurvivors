extends Node2D

const TWEEN_TRANSFORM_DURATION: float = 0.5
const TWEEN_SCALE_DURATION: float = 0.1

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	$Area2D.area_entered.connect(on_area_entered)


func tween_collect(percent: float, start_pos: Vector2) -> void:
	var player = get_tree().get_first_node_in_group('player') as Node2D
	if player == null: return
	
	global_position = start_pos.lerp(player.global_position, percent)
	
	var direction_from_start = player.global_position - start_pos
	var target_rotation = direction_from_start.angle() + PI/2
	rotation = lerp_angle(rotation, target_rotation, 1 - exp(-2 * get_process_delta_time()))


func collect() -> void:
	GameEvents.emit_experience_vial_collected(1)
	queue_free()


func disable_collision() -> void:
	collision_shape_2d.disabled = true


func on_area_entered(_other_area: Area2D) -> void:
	Callable(disable_collision).call_deferred()
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, TWEEN_TRANSFORM_DURATION)\
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, 'scale', Vector2.ZERO, TWEEN_SCALE_DURATION).set_delay(TWEEN_TRANSFORM_DURATION - TWEEN_SCALE_DURATION)
	tween.chain()
	tween.tween_callback(collect)
