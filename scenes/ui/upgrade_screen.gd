extends CanvasLayer

@onready var card_container: HBoxContainer = %CardContainer

@export var upgrade_card_scene: PackedScene


func _ready() -> void:
	get_tree().paused = true


func set_ability_upgrades(ability_upgrades: Array[AbilityUpgrade]) -> void:
	for upgrade in ability_upgrades:
		var card_instance = upgrade_card_scene.instantiate()
		card_container.add_child(card_instance)
		card_instance.set_ability_upgrade(upgrade)
