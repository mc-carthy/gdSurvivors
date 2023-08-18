extends Node

const MAX_RANGE = 150
const SWORD_SPAWN_OFFSET = 5

@export var sword_ability: PackedScene

var damage = 5

func _ready() -> void:
	$Timer.timeout.connect(on_timer_timeout)


func on_timer_timeout() -> void:
	var enemies = get_tree().get_nodes_in_group('enemy') as Array[Node2D]
	if enemies.size() == 0:
		return

	var player = get_tree().get_first_node_in_group('player') as Node2D
	if player == null:
		return

	var nearby_enemies = enemies.filter(func(enemy: Node2D): 
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
	)
	
	if nearby_enemies.size() == 0:
		return
	
	nearby_enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
		var b_distance = b.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
		return a_distance < b_distance
	)
	
	var nearest_enemy = nearby_enemies[0] as Node2D
	
	var sword_instance = sword_ability.instantiate() as SwordAbility
	player.get_parent().add_child(sword_instance)
	sword_instance.hitbox_component.damage = damage
	sword_instance.global_position = nearest_enemy.global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * SWORD_SPAWN_OFFSET
	
	var enemy_direction = nearest_enemy.global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()
