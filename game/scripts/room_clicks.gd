class_name RoomClicks
extends RefCounted
## Sends a click on a prop, hotspot or character to the current room's script, if that room is
## a ReemRoom. Shared by RoomProp, RoomHotspot and NpcCharacter.


static func clicked(obj: PopochiuClickable) -> void:
	var room := R.current as ReemRoom
	if room:
		await room.object_clicked(obj)
	else:
		await obj.get_tree().process_frame


static func item_used(obj: PopochiuClickable, item: PopochiuInventoryItem) -> void:
	var room := R.current as ReemRoom
	if room:
		await room.item_used_on(obj, item)
	else:
		await obj.get_tree().process_frame
