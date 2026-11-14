class_name ReemParallax
extends Node2D
## Three horizontal depth masks; keeps all click targets and the path stationary.
@export var depth_pixels := Vector3(3.0, 1.5, 0.0)
var _source: Sprite2D
var _layers: Array[Sprite2D] = []
var _center := 960.0
const MASK := "shader_type canvas_item; uniform float top = 0.0; uniform float bottom = 1.0; void fragment(){ vec4 c = texture(TEXTURE, UV); float a = smoothstep(top-0.025, top+0.025, UV.y)*(1.0-smoothstep(bottom-0.025,bottom+0.025,UV.y)); COLOR = vec4(c.rgb,c.a*a); }"
func _ready() -> void:
	_source = get_parent().get_node("Background")
	_center = C.player.position.x if is_instance_valid(C.player) else 960.0
	for index in 3:
		var layer := Sprite2D.new()
		layer.name = ["FarSky", "MiddleLandscape", "NearGround"][index]
		layer.centered = false
		layer.z_index = -99 + index
		var material := ShaderMaterial.new()
		var shader := Shader.new()
		shader.code = MASK
		material.shader = shader
		material.set_shader_parameter("top", [-.1, .35, .7][index])
		material.set_shader_parameter("bottom", [.35, .7, 1.1][index])
		layer.material = material
		add_child(layer)
		_layers.append(layer)
func _process(delta: float) -> void:
	if not is_instance_valid(_source) or not is_instance_valid(C.player):
		return
	var offset := clampf((C.player.position.x - _center) / 900.0, -1, 1)
	for index in 3:
		var layer := _layers[index]
		layer.texture = _source.texture
		layer.scale = _source.scale
		var goal := _source.position - Vector2(offset * depth_pixels[index], 0)
		layer.position = layer.position.lerp(goal, 1.0 - exp(-delta * 5.0))
