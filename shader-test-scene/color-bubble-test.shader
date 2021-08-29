shader_type canvas_item;

uniform float uniform_h : hint_range(0, 360, 1.0);
uniform float uniform_s : hint_range(0, 100, 1.0);
uniform float uniform_l : hint_range(0, 100, 1.0);
uniform float uniform_a : hint_range(0.0, 1.0);

vec3 hsl_to_rgb(vec3 hsl) {
    float h = hsl.x;
    float s = hsl.y;
    float l = hsl.z;

    if (s == 0.0) return vec3(l, l, l);

    float tmp1, tmp2;

    if (l >= 50.0) {
        tmp1 = (l + s) - (l * s);
    } else {
        tmp1 = l * (1.0 + s);
    }

    tmp2 = (2.0 * l) - tmp1;

    float r, g, b;

    float tmpR = mod(h + 0.333, 1.0);
    if ((6.0 * tmpR) < 1.0) {
        r = tmp2 + ((tmp1 - tmp2) * 6.0 * tmpR);
    } else if ((2.0 * tmpR) < 1.0) {
        r = tmp1;
    } else if ((3.0 * tmpR) < 2.0) {
        r = tmp2 + ((tmp1 - tmp2) * ((0.666 - tmpR) * 6.0));
    } else {
        r = tmp2;
    }

    float tmpG = h;
    if ((6.0 * tmpG) < 1.0) {
        g = tmp2 + ((tmp1 - tmp2) * 6.0 * tmpG);
    } else if ((2.0 * tmpG) < 1.0) {
        g = tmp1;
    } else if ((3.0 * tmpG) < 2.0) {
        g = tmp2 + ((tmp1 - tmp2) * ((0.666 - tmpG) * 6.0));
    } else {
        g = tmp2;
    }

    float tmpB = mod(h - 0.333, 1.0);
    if ((6.0 * tmpB) < 1.0) {
        b = tmp2 + ((tmp1 - tmp2) * 6.0 * tmpB);
    } else if ((2.0 * tmpB) < 1.0) {
        b = tmp1;
    } else if ((3.0 * tmpB) < 2.0) {
        b = tmp2 + ((tmp1 - tmp2) * ((0.666 - tmpB) * 6.0));
    } else {
        b = tmp2;
    }

    if (r < 0.0) r = 0.0;
    if (g < 0.0) g = 0.0;
    if (b < 0.0) b = 0.0;

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

    vec3 hsl = vec3(uniform_h / 360.0, uniform_s / 100.0, uniform_l / 100.0);

    vec4 color = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
    vec4 overlay = vec4(hsl_to_rgb(hsl), uniform_a);
    COLOR = blend_screeen(color, overlay);

    vec2 uv = UV * 2. - 1.;
    float dist = sqrt(uv.x * uv.x + uv.y * uv.y);

    // COLOR.b = 1.0;

    if (dist < FADE_START) {
        COLOR.a = 1.0;
    } else if (dist < FADE_END) {
        float fade = 1.0 - ((dist - FADE_START) / (FADE_END - FADE_START));
        COLOR.a = fade;
    } else {
        COLOR.a = 0.0;
    }
}
