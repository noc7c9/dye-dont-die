shader_type canvas_item;

uniform int shades;

void fragment() {
    float v = floor(UV.x * float(shades)) / float(shades - 1);
    COLOR = vec4(v, v, v, 1.0);
}