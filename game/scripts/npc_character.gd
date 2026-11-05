@tool
class_name NpcCharacter
extends PopochiuCharacter
## Shared behavior of the characters Reem talks to (Jad, Thaaloob, Shahd), game_spec.md 3:
## - a moving mouth while speaking (no size change: user request),
## - clicks are handled by the room script (ReemRoom._on_object_clicked), like props.
##
## To make a character look the other way, give its Sprite2D a negative scale.x (not flip_h:
## Popochiu resets flip_h when the character is added to a room).



#region Virtual ####################################################################################
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


func _play_talk() -> void:
	_set_mouth_talking(true)


func _play_idle() -> void:
	_set_mouth_talking(false)


## The mouth (a TalkingMouth under Sprite2D) opens and closes while speaking.
func _set_mouth_talking(value: bool) -> void:
	var mouth := get_node_or_null("Sprite2D/Mouth") as TalkingMouth
	if mouth:
		mouth.talking = value


func _play_walk(_target_pos: Vector2) -> void:
	pass


func _play_grab() -> void:
	grab_done.emit.call_deferred()


#endregion
