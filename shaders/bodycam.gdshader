shader_type canvas_item;

uniform float width_scale : hint_range(0.1, 2.0, 0.01) = 1.0;
uniform float height_scale : hint_range(0.1, 2.0, 0.01) = 1.0;
uniform float distortion = 1.0;
uniform float radius : hint_range(0.0, 2.0, 0.01) = 1.07;
uniform float alpha : hint_range(0.0, 1.0, 0.1) = 1.0;
uniform float crop : hint_range(0.0, 1.5, 0.01) = 0.943;
uniform vec4 crop_color : source_color = vec4(0, 0, 0, 1);
uniform float crop_feathering : hint_range(0.0, 0.5, 0.01) = 0.1;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

const float base_distortion = 0.99;
uniform float channel_offset : hint_range(-0.1, 0.1, 0.001) = 0.005;
uniform float noise_strength : hint_range(0.0, 10.0, 0.1) = 5.0;

vec2 distort(vec2 p) {
    float d = length(p);
    float z = sqrt(distortion + d * d * -distortion);
    float r = atan(d, z) / 3.1415926535;
    float phi = atan(p.y, p.x);
    return vec2(r * cos(phi) / width_scale + 0.5, r * sin(phi) / height_scale + 0.5);
}

void fragment() {
    vec2 xy = (SCREEN_UV * 2.0 - 1.0);
    xy = vec2(xy.x * width_scale, xy.y * height_scale);
    float d = length(xy);
    vec4 tex;

    if (d < radius) {
        vec2 distorted_uv_r = distort(xy * (base_distortion + 0.0 * channel_offset));
        vec2 distorted_uv_g = distort(xy * (base_distortion + 1.0 * channel_offset));
        vec2 distorted_uv_b = distort(xy * (base_distortion + 2.0 * channel_offset));

        tex.r = texture(SCREEN_TEXTURE, distorted_uv_r).r;
        tex.g = texture(SCREEN_TEXTURE, distorted_uv_g).g;
        tex.b = texture(SCREEN_TEXTURE, distorted_uv_b).b;

        float x = (UV.x + 4.0) * (UV.y + 4.0) * (TIME * 10.0);
        tex += vec4(mod((mod(x, 13.0)) * (mod(x, 123.0)), 0.01) - 0.005) * noise_strength;

        COLOR = tex;
        COLOR.a = alpha;
    }

    if (d > crop) {
        float softness = smoothstep(crop, crop + crop_feathering, d);
        COLOR = mix(tex, crop_color, softness);
        COLOR.a = alpha;
    }
}
