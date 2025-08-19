shader_type spatial;

uniform sampler2D albedo_texture : source_color;
uniform vec3 emission_color : source_color = vec3(1.0, 0.5, 0.0);
uniform float emission_strength = 1.0;
uniform float black_threshold = 0.05;

void fragment() {
    vec4 tex_color = texture(albedo_texture, UV);

    float luminance = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));

    ALBEDO = tex_color.rgb;

    if (luminance > black_threshold) {
        EMISSION = emission_color.rgb * emission_strength * tex_color.rgb;
    } else {
        EMISSION = vec3(0.0);
    }
}