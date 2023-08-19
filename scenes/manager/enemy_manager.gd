extends Node

@export var basic_enemy_scene: PackedScene

var spawn_radius: float

func _ready() -> void:
	spawn_radius = (get_tree().root.get_visible_rect().size.length() / 2) + 10
	$Timer.timeout.connect(on_timer_timeout)


func on_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group('player') as Node2D
	if player == null:
		return

	var direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position = player.global_position + (direction * spawn_radius)
	
	var enemy = basic_enemy_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group('entities_layer')
	entities_layer.add_child(enemy)
	enemy.global_position = spawn_position
