shader_type canvas_item;

/*******************************************************************************
 * Uniforms
 */

uniform float chroma;
uniform float hue : hint_range(0, 360);

/*******************************************************************************
 * Circle Shape
 */

vec4 circle(vec2 uv, vec4 color) {
    float FADE_START = 0.99;
    float FADE_END = 1.0;

    uv = uv * 2. - 1.;
    float dist = sqrt(uv.x * uv.x + uv.y * uv.y);

    if (dist < FADE_START) {
        color.a = 1.0;
    } else if (dist < FADE_END) {
        float fade = 1.0 - ((dist - FADE_START) / (FADE_END - FADE_START));
        color.a = fade;
    } else {
        color.a = 0.0;
    }

    return color;
}

/*******************************************************************************
 * Color Conversions
 *
 * source: http://www.easyrgb.com/en/math.php
 */

vec3 cielch_to_cielab(vec3 lch) {
    float l = lch.x;
    float c = lch.y;
    float h = lch.z;

    float a = cos(radians(h)) * c;
    float b = sin(radians(h)) * c;

    return vec3(l, a, b);
}
vec3 cielab_to_cielch(vec3 lab) {
    float l = lab.x;
    float a = lab.y;
    float b = lab.z;

    float h = atan(b, a);
    h = h > 0.0 ? degrees(h) : 360.0 - degrees(abs(h));

    float c = sqrt(a * a + b * b);

    return vec3(l, c, h);
}

float _cielab_to_xyz(float v) {
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

    float x = _cielab_to_xyz(tmp_x) * 95.047; // D65 2 deg reference
    float y = _cielab_to_xyz(tmp_y) * 100.000;
    float z = _cielab_to_xyz(tmp_z) * 108.883;

    return vec3(x, y, z);
}
float _xyz_to_cielab(float v) {
    return v > 0.008856 ? pow(v, 1.0/3.0) : (7.787 * v) + (16.0 / 116.0);
}
vec3 xyz_to_cielab(vec3 xyz) {
    float x = _xyz_to_cielab(xyz.x / 95.047); // D65 2 deg reference
    float y = _xyz_to_cielab(xyz.y / 100.000);
    float z = _xyz_to_cielab(xyz.z / 108.883);

    float l = 116.0 * y - 16.0;
    float a = 500.0 * (x - y);
    float b = 200.0 * (y - z);

    return vec3(l, a, b);
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
float _srgb_to_xyz(float v) {
    return v > 0.04045 ? pow((v + 0.055) / 1.055, 2.4) : v / 12.92;
}
vec3 srgb_to_xyz(vec3 srgb) {
    float r = _srgb_to_xyz(srgb.x) * 100.0;
    float g = _srgb_to_xyz(srgb.y) * 100.0;
    float b = _srgb_to_xyz(srgb.z) * 100.0;

    float x = r * 0.4124 + g * 0.3576 + b * 0.1805;
    float y = r * 0.2126 + g * 0.7152 + b * 0.0722;
    float z = r * 0.0193 + g * 0.1192 + b * 0.9505;

    return vec3(x, y, z);
}

vec4 blend_screeen(vec4 dst, vec4 src) {
    return vec4(
        1.0 - (1.0 - src.r * src.a) * (1.0 - dst.r),
        1.0 - (1.0 - src.g * src.a) * (1.0 - dst.g),
        1.0 - (1.0 - src.b * src.a) * (1.0 - dst.b),
        1.0
    );
}

/*******************************************************************************
 * Fragment Shader
 */

void fragment() {
    // create color by taking the luminocity of the texture color and changing
    // the chroma and hue
    vec4 tex = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
    float luminocity = cielab_to_cielch(xyz_to_cielab(srgb_to_xyz(tex.xyz))).x;

    vec3 lch = vec3(luminocity, chroma, hue);
    vec3 srgb = xyz_to_srgb(cielab_to_xyz(cielch_to_cielab(lch)));

    vec4 color = vec4(srgb, 1.0);

    COLOR = circle(UV, color);
}
