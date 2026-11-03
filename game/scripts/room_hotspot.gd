@tool
class_name RoomHotspot
extends PopochiuHotspot
## A hotspot (an area of the background, or an exit) whose clicks are handled by its room script
## (ReemRoom._on_object_clicked and ReemRoom._on_item_used_on). Clicks the room does not handle
## do nothing (CLAUDE.md rule 7).


func _on_click() -> void:
	await RoomClicks.clicked(self)


func _on_double_click() -> void:
	await RoomClicks.clicked(self)


func _on_right_click() -> void:
	await RoomClicks.clicked(self)


func _on_middle_click() -> void:
	pass


func _on_item_used(item: PopochiuInventoryItem) -> void:
	await RoomClicks.item_used(self, item)
