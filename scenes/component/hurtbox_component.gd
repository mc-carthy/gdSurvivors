extends Area2D
class_name HurtboxComponent

@export var health_component: Node

var floating_text_scene = preload('res://scenes/ui/floating_text.tscn')
var floating_text_y_offset: float = 16


func _ready() -> void:
	area_entered.connect(on_area_entered)


func on_area_entered(other_area: Area2D) -> void:
	if not other_area is HitboxComponent: return
	if health_component == null: return
	
	var hitbox_component = other_area as HitboxComponent
	health_component.damage(hitbox_component.damage)

	var floating_text = floating_text_scene.instantiate() as Node2D
	get_tree().get_first_node_in_group('foreground_layer').add_child(floating_text)
	
	floating_text.global_position = global_position + (Vector2.UP * floating_text_y_offset)
	floating_text.start(str(hitbox_component.damage))
