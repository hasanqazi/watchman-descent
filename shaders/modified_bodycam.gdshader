shader_type canvas_item;

// Uniforms for distortion and effects
uniform float width_scale : hint_range(0.1, 2.0, 0.01) = 1.0;
uniform float height_scale : hint_range(0.1, 2.0, 0.01) = 1.0;
uniform float distortion = 1.0;
uniform float radius : hint_range(0.0, 2.0, 0.01) = 1.07;
uniform float alpha : hint_range(0.0, 1.0, 0.1) = 1.0;
uniform float crop : hint_range(0.0, 1.5, 0.01) = 0.943;
uniform vec4 crop_color : source_color = vec4(0, 0, 0, 1);
uniform float crop_feathering : hint_range(0.0, 0.5, 0.01) = 0.1;

uniform float shake : hint_range(0, 10) = 0.015;
uniform float noiseQuality : hint_range(0.1, 250, 0.1) = 250;
uniform float noiseIntensity : hint_range(0, 0.05, 0.001) = 0.001;
uniform float offsetIntensity : hint_range(0, 0.05, 0.0001) = 0.0045;
uniform float colorOffsetIntensity : hint_range(0.0, 1.5, 0.001) = 0.2;
uniform float pixelSize : hint_range(1, 1024) = 200.0;
uniform float grainIntensity : hint_range(0, 1) = 0.04;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D overlay_texture : hint_default_transparent;
uniform bool use_overlay = true;
uniform bool use_lens_distortion = true;
uniform vec4 overlay_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float lens_distortion_strength : hint_range(0, 0.1) = 0.05;

varying vec2 previous_pos; // Previous fragment position

const float base_distortion = 0.99;

// Utility functions
vec2 distort(vec2 p) {
    float d = length(p);
    float z = sqrt(distortion + d * d * -distortion);
    float r = atan(d, z) / 3.1415926535;
    float phi = atan(p.y, p.x);
    return vec2(r * cos(phi) / width_scale + 0.5, r * sin(phi) / height_scale + 0.5);
}

float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

float verticalBar(float pos, float uvY, float offset) {
    float edge0 = (pos - shake);
    float edge1 = (pos + shake);
    float x = smoothstep(edge0, pos, uvY) * offset;
    x -= smoothstep(pos, edge1, uvY) * offset;
    return x;
}

void fragment() {
    vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
    vec2 uv = FRAGCOORD.xy / iResolution.xy;

    // Pixelation effect
    uv = floor(uv * pixelSize) / pixelSize;

    // Add vertical bars distortion
    for (float i = 0.0; i < 0.71; i += 0.1313) {
        float d = mod(TIME * i, 1.7);
        float o = sin(1.0 - tan(TIME * 0.24 * i));
        o *= offsetIntensity;
        uv.x += verticalBar(d, uv.y, o);
    }

    // Add noise distortion
    float uvY = uv.y * noiseQuality;
    uvY = float(int(uvY)) * (1.0 / noiseQuality);
    float noise = rand(vec2(TIME * 0.00001, uvY));
    uv.x += noise * noiseIntensity;

    // Add color offset distortion
    vec2 offsetR = vec2(0.006 * sin(TIME), 0.0) * colorOffsetIntensity;
    vec2 offsetG = vec2(0.0073 * cos(TIME * 0.97), 0.0) * colorOffsetIntensity;

    float r = texture(screen_texture, uv + offsetR).r;
    float g = texture(screen_texture, uv + offsetG).g;
    float b = texture(screen_texture, uv).b;

    vec4 tex = vec4(r, g, b, 1.0);

    // Lens distortion
    if (use_lens_distortion) {
        vec2 distortion_uv = uv * lens_distortion_strength * (uv - 1.0);
        vec4 distorted_tex = texture(screen_texture, uv + distortion_uv);
        tex = mix(tex, distorted_tex, 0.5);
    }

    // Overlay texture
    if (use_overlay) {
        vec4 overlayColor = texture(overlay_texture, uv) * overlay_color;
        tex = mix(tex, overlayColor, overlayColor.a);
    }

    // Add film grain
    float grain = rand(uv) * 2.0 - 1.0;
    tex.rgb += grainIntensity * grain;

    // Crop and feathering
    vec2 xy = (SCREEN_UV * 2.0 - 1.0);
    float d = length(xy);
    if (d > crop) {
        float softness = smoothstep(crop, crop + crop_feathering, d);
        tex = mix(tex, crop_color, softness);
    }

    // Apply final alpha
    tex.a = alpha;
    COLOR = tex;

    // Store current position for next frame
    previous_pos = FRAGCOORD.xy / iResolution.xy;
}
