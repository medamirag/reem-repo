shader_type canvas_item;
varying vec4 shirt_colour;
void vertex() { shirt_colour = COLOR; }
void fragment() {
    COLOR = shirt_colour;
}
