extends Node2D

const UPWARD_DISTANCE: float = 16.0
const TWEEN_OUT_DISTANCE_MULTIPLIER: float = 4.0
const SCALE_TWEEN_SIZE: float = 1.5
const TWEEN_DURATION: float = 0.3

func _ready() -> void:
	pass


func start(text: String) -> void:
	$Label.text = text
	
	var tween = create_tween()
	tween.set_parallel()
	
	tween.tween_property(self, 'global_position', global_position + Vector2.UP * UPWARD_DISTANCE, TWEEN_DURATION)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.chain()
	
	tween.tween_property(self, 'global_position', global_position + Vector2.UP * UPWARD_DISTANCE * TWEEN_OUT_DISTANCE_MULTIPLIER, TWEEN_DURATION * 2)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, 'scale', Vector2.ONE, TWEEN_DURATION * 2)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.chain()
	
	
	tween.tween_callback(queue_free)

	var scale_tween = create_tween()
	scale_tween.tween_property(self, 'scale', Vector2.ONE * SCALE_TWEEN_SIZE, TWEEN_DURATION / 2)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	scale_tween.tween_property(self, 'scale', Vector2.ONE, TWEEN_DURATION / 2)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
