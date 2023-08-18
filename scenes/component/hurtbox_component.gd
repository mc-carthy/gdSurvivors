extends Area2D
class_name HurtboxComponent

@export var health_component: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(on_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_area_entered(other_area: Area2D) -> void:
	if not other_area is HitboxComponent: return
	if health_component == null: return
	
	var hitbox_component = other_area as HitboxComponent
	health_component.damage(hitbox_component.damage)
