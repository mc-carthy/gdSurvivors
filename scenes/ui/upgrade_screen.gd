extends CanvasLayer

signal upgrade_selected(upgrade: AbilityUpgrade)

@onready var card_container: HBoxContainer = %CardContainer

@export var upgrade_card_scene: PackedScene


func _ready() -> void:
	get_tree().paused = true


func set_ability_upgrades(ability_upgrades: Array[AbilityUpgrade]) -> void:
	var delay = 0.0
	for upgrade in ability_upgrades:
		var card_instance = upgrade_card_scene.instantiate()
		card_container.add_child(card_instance)
		card_instance.set_ability_upgrade(upgrade)
		card_instance.play_in(delay)
		card_instance.selected.connect(on_upgrade_selected.bind(upgrade))
		delay += 0.2

func on_upgrade_selected(upgrade: AbilityUpgrade) -> void:
	upgrade_selected.emit(upgrade)
	$AnimationPlayer.play('out')
	await $AnimationPlayer.animation_finished
	get_tree().paused = false
	queue_free()
