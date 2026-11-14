shader_type canvas_item;
varying vec4 part_modulate;
void vertex() { part_modulate = COLOR; }
void fragment() {
    vec2 p = UV * vec2(1254.0);
    float down = smoothstep(440.0, 850.0, p.y);
    float side = 1.0 - smoothstep(500.0, 750.0, p.x);
    vec3 fabric = mix(vec3(.161, .698, .671), vec3(.125, .647, .639), down);
    fabric -= vec3(.018, .022, .020) * side;
    vec4 source = texture(TEXTURE, UV);
    if (p.y >= 780.0 && source.a > .9 && source.g > .25 && source.b > .25 && source.g > source.r * 1.2 && source.b > source.r * 1.2) {
        fabric = mix(fabric, source.rgb, smoothstep(780.0, 860.0, p.y));
    }
    COLOR = vec4(fabric, 1.0) * part_modulate;
}
