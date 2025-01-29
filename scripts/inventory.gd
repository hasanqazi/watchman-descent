extends Node3D

var items = []

func _ready() -> void:
	SignalBus.add_item_to_inv.connect(_add_item_to_inv)

func update_items() -> void:
	items = get_children()
 
func _add_item_to_inv(item: Node3D) -> void:
	print("Adding item: ", item)
				   
	if item.get_parent():
		item.get_parent().remove_child(item)
	
	add_child(item)
	item.global_position = global_position
	item.global_rotation = global_rotation
	update_items()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("activate"):
		activate_item()

func activate_item() -> void:
	if !items.is_empty() and Global.player_immobile == false:
		items[0].activate()
