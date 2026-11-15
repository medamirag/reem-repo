extends SceneTree
func _initialize() -> void:
 var failed := false
 for name in ['grandpa','fox']:
  var scene: PackedScene = load('res://game/rig_parts/%s/static_rig.tscn' % name)
  if scene==null:
   failed=true
   continue
  var actor=scene.instantiate()
  root.add_child(actor)
  var bones=actor.find_children('*','Bone2D',true,false)
  if bones.size()<15 or actor.find_children('*','AnimationPlayer',true,false).size()>0:failed=true
  var layout=JSON.parse_string(FileAccess.get_file_as_string('res://game/rig_parts/%s/layout.json' % name))
  var expected=Vector2(layout.canvas[0]/2.0-layout.root[0],layout.canvas[1]/2.0-layout.root[1])
  if actor.texture_filter!=CanvasItem.TEXTURE_FILTER_LINEAR:failed=true
  for sprite in actor.find_children('*','Sprite2D',true,false):
   if sprite.texture==null:failed=true
   if (sprite.global_transform * sprite.offset).distance_to(expected)>.01:failed=true
  print('[FABLE BONES] ',name,' static bones=',bones.size())
  actor.queue_free()
 print('[FABLE BONES] FAILED' if failed else '[FABLE BONES] DONE')
 quit(1 if failed else 0)
