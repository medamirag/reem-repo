extends PopochiuRoomData
# Add variables here that should be saved and restored with the room state.
# By default only Godot's built-in types are saved/loaded automatically.
# Use `save_custom` and `load_custom` to handle custom data types.
# Note: `script_name` and `scene` variables inherited from the base class are not saved.


#region Virtual ####################################################################################
func _on_save() -> Dictionary:
	return {}


func _on_load(data: Dictionary) -> void:
	prints(data)


#endregion
