extends Node

const MAX_SPAWN_RATE = 0.7

@export var basic_enemy_scene: PackedScene
@export var arena_time_manager: Node

@onready var timer: Timer = $Timer

var spawn_radius: float
var base_spawn_time: float

func _ready() -> void:
	base_spawn_time = timer.wait_time
	spawn_radius = (get_tree().root.get_visible_rect().size.length() / 2) + 10
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)


func on_timer_timeout() -> void:
	timer.start()
	
	var player = get_tree().get_first_node_in_group('player') as Node2D
	if player == null:
		return

	var direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position = player.global_position + (direction * spawn_radius)
	
	var enemy = basic_enemy_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group('entities_layer')
	entities_layer.add_child(enemy)
	enemy.global_position = spawn_position

func on_arena_difficulty_increased(arena_difficulty: int) -> void:
	var time_off = (0.1 / 12) * arena_difficulty
	time_off = min(time_off, MAX_SPAWN_RATE)
	timer.wait_time = base_spawn_time - time_off
