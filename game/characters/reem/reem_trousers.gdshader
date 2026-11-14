shader_type canvas_item;
uniform float walking : hint_range(0.0, 1.0) = 0.0;
uniform bool cap_mode = false;
varying vec4 part_modulate;
void vertex() { part_modulate = COLOR; }
void fragment() {
    vec4 cloth = texture(TEXTURE, UV);
    if (cap_mode) {
        cloth.a *= walking;
    } else if (UV.y < 1020.0 / 1254.0) {
        // The source coat border must not turn into an outline across the trousers.
        cloth.a *= 1.0 - walking;
    }
    COLOR = cloth * part_modulate;
}
