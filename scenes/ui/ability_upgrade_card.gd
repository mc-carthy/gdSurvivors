extends PanelContainer

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel

var disabled = false

signal selected


func _ready() -> void:
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)


func set_ability_upgrade(upgrade: AbilityUpgrade) -> void:
	name_label.text = upgrade.name
	description_label.text = upgrade.description


func play_in(delay: float = 0) -> void:
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	$AnimationPlayer.play('in')


func play_discard() -> void:
	$AnimationPlayer.play('discard')


func select_card() -> void:
	disabled = true
	$AnimationPlayer.play('selected')
	
	for other_card in get_tree().get_nodes_in_group('upgrade_card'):
		if other_card == self: continue
		other_card.play_discard()
	
	await $AnimationPlayer.animation_finished
	selected.emit()


func on_gui_input(event: InputEvent) -> void:
	if disabled: return
	if event.is_action_pressed('left_click'):
		select_card()

func on_mouse_entered() -> void:
	if disabled: return
	$HoverAnimation.play('hover')
