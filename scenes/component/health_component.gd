extends Node
class_name HealthComponent

signal died

@export var max_health: float = 10
@export var current_health: float


func _ready() -> void:
	current_health = max_health


func damage(damage_amount: float) -> void:
	current_health -= damage_amount
	Callable(check_death).call_deferred()

func check_death() -> void:
	if current_health <= 0:
		died.emit()
		owner.queue_free()
