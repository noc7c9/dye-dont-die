shader_type canvas_item;

void fragment() {
    float v = UV.x;
    COLOR = vec4(v, v, v, 1.0);
}