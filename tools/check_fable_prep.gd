extends SceneTree
func _initialize() -> void:
 var failed := false
 for name in ['dew_bank','narrow_pass']:
  var scene: PackedScene = load('res://game/rooms/%s/room_%s.tscn' % [name,name])
  var room = scene.instantiate()
  for key in room.entry_points:
   var p: Vector2 = room.entry_points[key]
   if minf(p.x*1920.0-95.0,1825.0-p.x*1920.0)<250.0:failed=true
  room.free()
  print('[FABLE CHECK] entry clearance ',name,' ok')
 var file := FileAccess.open('res://docs/rigs/audio_manifest.json',FileAccess.READ)
 for row in JSON.parse_string(file.get_as_text()):
  var audio := AudioStreamMP3.new()
  audio.data=FileAccess.get_file_as_bytes('res://'+row.path)
  if audio.get_length()<=.2:failed=true
  print('[FABLE CHECK] audio ',row.id,' duration=',audio.get_length())
 print('[FABLE CHECK] FAILED' if failed else '[FABLE CHECK] DONE')
 quit(1 if failed else 0)
