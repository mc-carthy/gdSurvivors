extends Node

const MAX_SPAWN_RATE = 0.7
const WIZARD_DIFFICULTY_SPAWN_LEVEL = 6

@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var arena_time_manager: Node

@onready var timer: Timer = $Timer

var spawn_radius: float
var base_spawn_time: float
var basic_enemy_scene_weight: int = 10 
var wizard_enemy_scene_weight: int = 20
var enemy_table = WeightedTable.new()

func _ready() -> void:
	base_spawn_time = timer.wait_time
	spawn_radius = (get_tree().root.get_visible_rect().size.length() / 2) + 10
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)
	enemy_table.add_item(basic_enemy_scene, basic_enemy_scene_weight)
#	enemy_table.add_item(wizard_enemy_scene, wizard_enemy_scene_weight)

func get_spawn_position() -> Vector2:
	var player = get_tree().get_first_node_in_group('player') as Node2D
	if player == null:
		return Vector2.ZERO
	
	var spawn_position = Vector2.ZERO
	var direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	for i in 4:	

		spawn_position = player.global_position + (direction * spawn_radius)
		
		var query_params = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_params)
	
		if result.is_empty():
			break
		else:
			direction = direction.rotated(PI / 2)
	
	return spawn_position
 


func on_timer_timeout() -> void:
	timer.start()
	
	var player = get_tree().get_first_node_in_group('player') as Node2D
	if player == null:
		return
	
	var enemy_scene = enemy_table.pick_item() as PackedScene
	var enemy = enemy_scene.instantiate() as Node2D
	
	var entities_layer = get_tree().get_first_node_in_group('entities_layer')
	entities_layer.add_child(enemy)
	enemy.global_position = get_spawn_position()

func on_arena_difficulty_increased(arena_difficulty: int) -> void:
	var time_off = (0.1 / 12) * arena_difficulty
	time_off = min(time_off, MAX_SPAWN_RATE)
	timer.wait_time = base_spawn_time - time_off
	
	if arena_difficulty == WIZARD_DIFFICULTY_SPAWN_LEVEL:
		enemy_table.add_item(wizard_enemy_scene, wizard_enemy_scene_weight)
