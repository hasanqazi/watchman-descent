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
	
	if !items.is_empty():
		items[0].equipped = true
