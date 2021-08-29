shader_type canvas_item;

uniform float uniform_l : hint_range(0, 100);
uniform float uniform_c;
uniform float uniform_h : hint_range(0, 360);
uniform float uniform_a : hint_range(0.0, 1.0);

// source: http://www.easyrgb.com/en/math.php

vec3 cielch_to_cielab(vec3 lch) {
    float l = lch.x;
    float c = lch.y;
    float h = lch.z;

    float a = cos(radians(h)) * c;
    float b = sin(radians(h)) * c;

    return vec3(l, a, b);
}

float _to_xyz(float v) {
    float v3 = pow(v, 3.0);
    return v3 > 0.008856 ? v3 : (v - 16.0 / 116.0) / 7.787;
}

vec3 cielab_to_xyz(vec3 lab) {
    float l = lab.x;
    float a = lab.y;
    float b = lab.z;

    float tmp_y = (l + 16.0) / 116.0;
    float tmp_x = a / 500.0 + tmp_y;
    float tmp_z = tmp_y - b / 200.0;

    float x = _to_xyz(tmp_x) * 95.047; // D65 2 deg reference
    float y = _to_xyz(tmp_y) * 100.000;
    float z = _to_xyz(tmp_z) * 108.883;

    return vec3(x, y, z);
}

float _to_rgb(float v) {
    return v > 0.0031308 ? 1.055 * pow(v, 1.0 / 2.4) - 0.055 : 12.92 * v;
}

vec3 xyz_to_srgb(vec3 xyz) {
    float x = xyz.x / 100.0;
    float y = xyz.y / 100.0;
    float z = xyz.z / 100.0;

    float r = _to_rgb(x *  3.2406 + y * -1.5372 + z * -0.4986);
    float g = _to_rgb(x * -0.9689 + y *  1.8758 + z *  0.0415);
    float b = _to_rgb(x *  0.0557 + y * -0.2040 + z *  1.0570);

    return vec3(r, g, b);
}

vec4 blend_screeen(vec4 dst, vec4 src) {
    return vec4(
        1.0 - (1.0 - src.r * src.a) * (1.0 - dst.r),
        1.0 - (1.0 - src.g * src.a) * (1.0 - dst.g),
        1.0 - (1.0 - src.b * src.a) * (1.0 - dst.b),
        1.0
    );
}

void fragment() {
    float FADE_START = 0.99;
    float FADE_END = 1.0;

    vec3 lch = vec3(uniform_l, uniform_c, uniform_h);
    vec3 srgb = xyz_to_srgb(cielab_to_xyz(cielch_to_cielab(lch)));

    vec4 color = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
    vec4 overlay = vec4(srgb, uniform_a);
    COLOR = blend_screeen(color, overlay);
    // COLOR = color;

    vec2 uv = UV * 2. - 1.;
    float dist = sqrt(uv.x * uv.x + uv.y * uv.y);

    if (dist < FADE_START) {
        COLOR.a = 1.0;
    } else if (dist < FADE_END) {
        float fade = 1.0 - ((dist - FADE_START) / (FADE_END - FADE_START));
        COLOR.a = fade;
    } else {
        COLOR.a = 0.0;
    }
}
