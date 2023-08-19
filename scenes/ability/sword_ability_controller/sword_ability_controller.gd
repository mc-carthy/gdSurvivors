extends Node

const MAX_RANGE = 150
const SWORD_SPAWN_OFFSET = 5
const UPGRADE_ID = 'sword_rate'

@export var sword_ability: PackedScene

var damage = 5
var base_wait_time: float

func _ready() -> void:
	base_wait_time = $Timer.wait_time
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


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
	var foreground_layer = get_tree().get_first_node_in_group('foreground_layer')
	foreground_layer.add_child(sword_instance)
	sword_instance.hitbox_component.damage = damage
	sword_instance.global_position = nearest_enemy.global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * SWORD_SPAWN_OFFSET
	
	var enemy_direction = nearest_enemy.global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()

func on_ability_upgrade_added(upgrade: AbilityUpgrade, currrent_upgrades: Dictionary) -> void:
	if upgrade.id != UPGRADE_ID: return
	var percent_reduction = currrent_upgrades[UPGRADE_ID]['quantity'] * 0.1
	$Timer.wait_time = base_wait_time * (1 - percent_reduction)
	$Timer.start()
	print($Timer.wait_time)
